require 'uri'
require 'net/http'

class Cost < ActiveRecord::Base

  def self.update_cost
    url = URI(ENV['URICost'])

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cost = Cost.where(["id = ?", 1]).first

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['AuthDeliveryRateAccount'], ENV['AuthDeliveryRatePassword']

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    newCost = arr['cost']
    if(cost.lastUpdate == 1)
      cost.lastUpdate = 2
      cost.cost2 = newCost
      cost.save!
    else if(cost.lastUpdate == 2)
           cost.lastUpdate = 3
           cost.cost3 = newCost
           cost.save!
         else
           cost.lastUpdate = 1
           cost.cost1 = newCost
           cost.save!
         end
    end
  end

  def self.create_cost
    url = URI(ENV['URICost'])

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cost = Cost.where(["id = ?", 1]).first

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['AuthDeliveryRateAccount'], ENV['AuthDeliveryRatePassword']

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    cost = Cost.new(cost1: arr['cost'], cost2: arr['cost'], cost3:arr['cost'], lastUpdate: 3)
    cost.save!
  end

  def self.ping_delivery_rate
    url = URI(ENV['URIDeliveryRates'])

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth ENV['AuthDeliveryRateAccount'], ENV['AuthDeliveryRatePassword']

    response = http.request(request)
  end

  def self.get_cost_weight aux_cost_weight
    if(aux_cost_weight.lastUpdate==1)
      cost_weight = aux_cost_weight.cost1
    else if(aux_cost_weight.lastUpdate == 2)
           cost_weight = aux_cost_weight.cost2
         else
           cost_weight = aux_cost_weight.cost3
         end
    end
    cost_weight
  end

end