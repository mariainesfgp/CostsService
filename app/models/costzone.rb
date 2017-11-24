require 'uri'
require 'net/http'

class Costzone < ActiveRecord::Base
  def self.update_cost_zones
    url = URI(ENV['URIAreas'])

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['AuthDeliveryRateAccount'], ENV['AuthDeliveryRatePassword']

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    arr.each do |item|
      item['costToAreas'].each do |cost|
        costZone = Costzone.where(["\"zoneFrom\" = ? and \"zoneTo\" = ?", item['id'].to_i, cost[0].to_i]).first
        if(costZone.lastUpdate == 1 )
          costZone.cost2 = cost[1]
          costZone.lastUpdate = 2
        else if(costZone.lastUpdate == 2)
               costZone.cost3 = cost[1]
               costZone.lastUpdate = 3
             else
               costZone.cost1 = cost[1]
               costZone.lastUpdate = 1
             end
        end
        costZone.save!
      end
    end
  end
end