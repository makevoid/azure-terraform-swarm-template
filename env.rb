require 'open3'
require 'ipaddr'
require 'yaml'

require_relative 'lib/cmd_lib'
require_relative 'lib/lib'
require_relative 'lib/deployer_config'

PATH = File.expand_path "../", __FILE__

STACK_ID = "02"
STACK_NAME = "dk-#{STACK_ID}" # docker-01, dk-02, dk-03 ...
STACK_PATH = "#{PATH}/stacks/#{STACK_NAME}"
DB_ID      = "1"

# static ips for deployed VMs
IP_VM_A = "172.17.0.4"
IP_VM_B = "172.17.0.5"

DEBUG = true

BASE_DOMAIN = "hostname.run"
DOMAIN_NAME = "#{STACK_NAME}.#{BASE_DOMAIN}"

AZURE_SUBSCRIPTION_AB_BIZSPARK_ID = "xxxx-xxx-xxx-xxx-xxxx" # used for env. validation

PROVISIONER_GIT_URI = "git@github.com:appliedblockchain/provisioner" # development
PROVISIONER_BRANCH = "azure"

DEPLOYER_HOST = "deployer.example.com" # note: slack based deployer not open source yet

DEPLOYER_CONFIG_GIT_URI = "git@github.com:makevoid/deployer-config"

DEPLOYER_CONFIG_STACK_CONF = { # deployer not open source yet
  stack_name: "azure-docker-swarm-app",
  github_repo: "azure-docker-swarm-app",
  containers: [
    "redis",
    "nginx",
    "app"
  ]
}

include CmdLib
include Lib
include DeployerConfig
