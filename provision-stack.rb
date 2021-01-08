require_relative 'env'


def main
  # NOTE: make sure all these lines are uncommented :D
  puts "Prerequisites"
  prereqs_check

  puts "Setup"
  # prepare rm: true  # set up the infra from scratch removing the last state and reprovisioning everything all the time (you need to delete the resource group)
  prepare rm: false

  puts "Terraform"
  write_stack_files
  execute_tf

  puts "DNS"
  dns_setup

  puts "Provisioning"
  clone_provisioner # todo move to prepare
  update_ssh_config

  print_ssh_check_instructions
  gets

  ssh_check
  provisioner_configure_vms

  puts "Deployer config"
  deployer_config_update domain: DOMAIN_NAME, stack_name: STACK_NAME

  puts "DB"
  provision_database

  puts "Setup Deployer SSH"
  deployer_setup_ssh
  deployer_setup_secrets
end

def prepare(rm:)
  create_stack_dir rm: rm
end

def execute_tf
  puts system "cd #{stack_dir} && terraform init"
  exe "cd #{stack_dir} && terraform plan -out plan.json . && terraform apply -auto-approve plan.json"
end

SSH_CONFIG_LOCAL_PATH = File.expand_path "~/.ssh/config"

def update_ssh_config
  ssh_config_orig = File.read SSH_CONFIG_LOCAL_PATH
  ssh_config = ssh_config_parse ssh_config_local: ssh_config_orig
  # p ssh_config if DEBUG
  File.open("#{SSH_CONFIG_LOCAL_PATH}.bak", "w")  { |f| f.write ssh_config_orig }
  File.open(SSH_CONFIG_LOCAL_PATH, "w")           { |f| f.write ssh_config      }
end

def ssh_config_parse(ssh_config_local:)
  split = ssh_config_local.split /--\(sd\)---/
  split_2 = "\n\n#{split[2]}" if split[2] && split[2] != "" && split[2] != "\n"
  ssh_host_config = "#{split[0]}#{split_2}\n"
  "#{ssh_host_config}#{ssh_config_new}"
end

def ssh_config_new
  "# ---(sd)---
# DK - Docker Swarm Terraform env

Host #{STACK_NAME}-bas.hostname.run
  User azureuser
  IdentityFile ~/.ssh/id_deployer1

Host #{IP_VM_A}
  User azureuser
  ProxyCommand ssh -W %h:%p #{STACK_NAME}-bas.hostname.run
  IdentityFile ~/.ssh/id_azure_bas

Host #{IP_VM_B}
  User azureuser
  ProxyCommand ssh -W %h:%p #{STACK_NAME}-bas.hostname.run
  IdentityFile ~/.ssh/id_azure_bas

# ---(sd)---
"
end

def ssh_config_deployer
  "
# DK - Docker Swarm Terraform env
Host #{STACK_NAME}-bas.hostname.run
  User azureuser

Host #{IP_VM_A}
  User azureuser
  ProxyCommand ssh -W %h:%p #{STACK_NAME}-bas.hostname.run
  IdentityFile ~/.ssh/id_azure_bas

Host #{IP_VM_B}
  User azureuser
  ProxyCommand ssh -W %h:%p #{STACK_NAME}-bas.hostname.run
  IdentityFile ~/.ssh/id_azure_bas
"
end

def clone_provisioner
  exe "cd #{PATH}/vendor && git clone #{PROVISIONER_GIT_URI}"
  pull = "git checkout #{PROVISIONER_BRANCH} && git pull origin #{PROVISIONER_BRANCH} --rebase=false"
  exe "cd #{PATH}/vendor/provisioner && #{pull}"
end

def ssh_check
  puts "if this command hangs it means your setup is "
  exe "ssh #{IP_VM_A} uptime"
end

def provisioner_configure_vms
  ips = "IP_A=#{IP_VM_A} IP_B=#{IP_VM_B}"
  exe "cd #{PATH}/vendor/provisioner/vm && CLI_RUN=1 #{ips} rake"
end

def provision_database
  db_exists = db_azure_resource
  exe "STACK_ID=#{STACK_ID} rake psql:create" unless db_exists
  puts "DB created"
end

def print_ssh_check_instructions
  # TODO: automate as we automated it for the bastion host
  puts "
  # execute these commands once to register the current VMs ssh keys
  ssh-keygen -f \"$HOME/.ssh/known_hosts\" -R \"#{STACK_NAME}-bas.hostname.run\"
  ssh-keygen -f \"$HOME/.ssh/known_hosts\" -R \"#{IP_VM_A}\"
  ssh-keygen -f \"$HOME/.ssh/known_hosts\" -R \"#{IP_VM_B}\"

  # execute these two individually on another terminal, add the host key and exit (press Ctrl-C there) for both
  ssh #{IP_VM_A}
  ssh #{IP_VM_B}

  # press Enter to proceed
  "
end

def prereqs_check_jq_installed
  exe "echo  \"{}\" | jq"
end

def prereqs_check_az_cli
  exe "az version"
end

def prereqs_check_tf_cli
  exe "terraform version"
end

def prereqs_check_az_config
  exe "az account list | jq -e '.[] | select(.id==\"#{AZURE_SUBSCRIPTION_AB_BIZSPARK_ID}\")'"
end

def prereqs_check_tf_config
  exe "az version"
end

def prereqs_check
  prereqs_check_jq_installed
  prereqs_check_az_cli
  prereqs_check_tf_cli
  prereqs_check_az_config
  prereqs_check_tf_config
end

def deployer_setup_ssh
  deployer = "root@#{DEPLOYER_HOST}"
  bastion = "#{STACK_NAME}-bas.hostname.run"

  File.open("#{PATH}/tmp/deployer-ssh-config.txt", "w") { |f| f.write ssh_config_deployer }
  exe "scp #{PATH}/tmp/deployer-ssh-config.txt #{deployer}:.ssh/config"

  # clear existing known hosts
  exe %Q(ssh #{deployer} "ssh-keygen -R \\"#{bastion}\\"")
  exe %Q(ssh #{deployer} "ssh-keygen -R \\"#{IP_VM_A}\\"")
  exe %Q(ssh #{deployer} "ssh-keygen -R \\"#{IP_VM_B}\\"")

  # add new key fingerprints to known hosts
  exe %Q(ssh #{deployer} "ssh-keyscan -H #{bastion} >> ~/.ssh/known_hosts")
  exe %Q(ssh #{deployer} "ssh #{bastion} \\"ssh-keyscan -H #{IP_VM_A}\\" >> ~/.ssh/known_hosts")
  exe %Q(ssh #{deployer} "ssh #{bastion} \\"ssh-keyscan -H #{IP_VM_B}\\" >> ~/.ssh/known_hosts")
end

def db_azure_resource_cmd
  "az postgres flexible-server show --resource-group #{STACK_NAME}-rg --name #{STACK_NAME}-psql-1"
end

def db_azure_resource
  system db_azure_resource_cmd
end

def db_url_get
  %x{#{db_azure_resource_cmd}  | jq -r \".fullyQualifiedDomainName\"}.strip
end

def db_password
  pass = File.read "#{STACK_PATH}/output_sql_password.txt"
  pass.strip
end

def deployer_setup_secrets
  postgres_host = db_url_get
  postgres_pass = db_password
  app_hostname  = DOMAIN_NAME
  puts "db host: #{postgres_host.inspect}"

  secrets_path = "#{PATH}/config/secrets"
  deployer_env = File.read "#{secrets_path}/deployer-env.tpl.sh"

  deployer_env.gsub! /<PG_HOST>/,     postgres_host
  deployer_env.gsub! /<PG_PASSWORD>/, postgres_pass
  deployer_env.gsub! /<APP_BASE_URL>/, app_hostname

  File.open("#{secrets_path}/deployer-env.sh", "w") { |f| f.write deployer_env }

  exe "scp #{secrets_path}/deployer-env.sh root@#{IP_VM_A}:deployer-env.sh"
end

def dns_setup_bastion
  bastion_ip = File.read "#{stack_dir}/output_bastion_ip.txt"
  bastion_domain = "#{STACK_NAME}-bas"
  exe "cd #{PATH}/dns && SUBDOMAIN=#{bastion_domain} IP=#{bastion_ip} rake"
end

def dns_setup_app_gateway
  app_gateway_ip = File.read "#{stack_dir}/output_app_gateway_ip.txt"
  app_gateway_domain = STACK_NAME
  exe "cd #{PATH}/dns && SUBDOMAIN=#{app_gateway_domain} IP=#{app_gateway_ip} rake"
end

STATE = { status: nil, thread: nil }

def cmd_sleep_setup
  Thread.abort_on_exception = true
  Thread.new do
    gets
    STATE[:status] = :ok
  end
  sleep 1
  Thread.new do
    sleep 90
    STATE[:thread].kill
  end
end

def sleep_thread
  Thread.new do
    STATE[:thread] = Thread.current
    loop do
      STATE[:thread].kill if STATE[:status] == :ok
      sleep 1
    end
  end
end

def dns_setup
  dns_setup_bastion
  dns_setup_app_gateway
  puts "waiting for the DNS to be propagated... (90s)"
  puts "press enter to skip the waiting time (note: you can't skip the first run)"
  cmd_sleep_setup
  thr = sleep_thread
  thr.join
end

main
