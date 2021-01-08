TF_ARGS = "-auto-approve"

desc "provision"
task :provision do
  sh "ruby provision-stack.rb"
end

namespace :psql do
  desc "create psql db"
  task :create do
    sh "ruby psql.rb"
  end
end

namespace :template do
  desc "setup"
  task :setup do
    sh "terraform init"
  end

  desc "run"
  task :run do
    sh "terraform plan -out plan.json . && terraform apply #{TF_ARGS} plan.json"
  end
end

task default: :provision
