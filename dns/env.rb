require 'bundler'
Bundler.require :default
require 'ipaddr'

DNSIMPLE_ACCOUNT_ID_DEFAULT   = 12345 # NOTE: replace with your dnsimple account id
DOMAIN_ROOT = "hostname.run"          # NOTE: your domain
ZONE_ID     = 123456                  # NOTE: dnsimple Zone id

DNSIMPLE_ACCESS_TOKEN = ENV["DNSIMPLE_ACCESS_TOKEN"]  || DNSIMPLE_ACCESS_TOKEN_DEFAULT
DNSIMPLE_ACCOUNT_ID   = ENV["DNSIMPLE_ACCOUNT_ID"]    || DNSIMPLE_ACCOUNT_ID_DEFAULT

class AccessTokenNotSet < StandardError; end
raise AccessTokenNotSet, "The Access Token is not currently set" unless DNSIMPLE_ACCESS_TOKEN

DNS = Dnsimple::Client.new access_token: DNSIMPLE_ACCESS_TOKEN
