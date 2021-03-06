require 'uri'
require 'net/http'

class Zone < ActiveRecord::Base

  def self.create_zones_and_cost_zones
    url = URI(ENV['URIAreas'])

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['AuthDeliveryRateAccount'], ENV['AuthDeliveryRatePassword']

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    arr.each do |item|
      zone = Zone.new
      zone.identify = item['id']
      zone.name = item['name']
      zone.polygon = item['polygon']
      zone.save!
      item['costToAreas'].each do |cost|
        costZonesNew = Costzone.new
        costZonesNew.zoneFrom = zone.identify
        costZonesNew.zoneTo = cost[0].to_i
        costZonesNew.cost1 = cost[1]
        costZonesNew.cost2 = cost[1]
        costZonesNew.cost3 = cost[1]
        costZonesNew.lastUpdate = 3
        costZonesNew.save!
      end
    end
  end

  def self.get_zone lat, long
    sql = 'SELECT * FROM zones WHERE st_contains(ST_GeomFromText(zones.polygon), ST_GeomFromText(?))'
    point = 'POINT('+lat+''+long+')'
    zone = Zone.find_by_sql([sql, point]).first.identify.to_i
    zone
  end
end