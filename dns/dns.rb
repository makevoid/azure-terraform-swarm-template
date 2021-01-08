require_relative 'env'

DEBUG = true

module DnsLib

  def dns_zones
    DNS.zones.list_zone_records DNSIMPLE_ACCOUNT_ID, DOMAIN_ROOT, filter: { type: "A" }
  end


  def dns_zone_present?(zone_name, zones:)
    zones.data.find do |zone|
      zone.name == zone_name
    end
  end

  def dns_create_or_update_record(name:, ip:)
    zones = dns_zones
    zone = dns_zone_present? name, zones: zones
    if zone
      dns_update_record zone_id: zone.id, ip: ip
    else
      dns_create_record name: name, ip: ip
    end
  end

  def dns_create_record(name:, ip:)
    puts "create record #{name.inspect}" if DEBUG
    DNS.zones.create_zone_record DNSIMPLE_ACCOUNT_ID, DOMAIN_ROOT, name: name, type: "A", content: ip
  end

  def dns_update_record(zone_id:, ip:)
    puts "update record #{zone_id}" if DEBUG
    DNS.zones.update_zone_record DNSIMPLE_ACCOUNT_ID, DOMAIN_ROOT, zone_id, content: ip, type: "A"
  end

end

include DnsLib

def set_record(name:, ip:)
  dns_create_or_update_record name: name, ip: ip
end

def main
  subdomain = ENV["SUBDOMAIN"]
  raise "SubdomainParameterError - please specify SUBDOMAIN - example: SUBDOMAIN=foo IP=1.2.3.4 rake" if !subdomain || subdomain.empty?

  ip_string = ENV["IP"]
  raise "IPParameterError - please specify IP - example: SUBDOMAIN=foo IP=1.2.3.4 rake" if !ip_string || ip_string.empty?
  ip = IPAddr.new ip_string
  set_record name: subdomain, ip: ip
end

main
