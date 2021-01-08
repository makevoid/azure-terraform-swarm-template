require 'securerandom'
require 'open3'
require_relative 'lib/cmd_lib'
include CmdLib

path = File.expand_path "../", __FILE__

STACK_ID = ENV["STACK_ID"] || "01"
STACK_NAME = "dk-#{STACK_ID}"
DB_ID = "1"

DB_USERNAME = "sd_adm"
DB_PASSWORD_FILE = "#{path}/stacks/#{STACK_NAME}/output_sql_password.txt"

def db_password_generate
  SecureRandom.alphanumeric 18
end

def db_password_save(password:)
  File.open(DB_PASSWORD_FILE, "w") { |f| f.write password }
end

def db_create
  password = db_password_generate
  exe "az postgres flexible-server create --resource-group dk-#{STACK_ID}-rg --name dk-#{STACK_ID}-psql-#{DB_ID} --location northeurope --vnet dk-#{STACK_ID}-vnet-priv --subnet dk-#{STACK_ID}-sub-db --version 12 --high-availability Enabled  --sku-name  Standard_D2s_v3 --backup-retention 7 --admin-user #{DB_USERNAME} --admin-password #{password}", debug: false
  db_password_save password: password
end

def main
  db_create
  puts "DB created!"
end

main
