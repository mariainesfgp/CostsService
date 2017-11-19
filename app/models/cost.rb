require 'uri'
require 'net/http'

class Cost < ActiveRecord::Base

  def self.UpdateCost
    url = URI("https://delivery-rates.mybluemix.net/cost")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cost = Cost.where(["id = ?", 1]).first

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

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

  def self.CreateCost
    url = URI("https://delivery-rates.mybluemix.net/cost")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cost = Cost.where(["id = ?", 1]).first

    request = Net::HTTP::Get.new(url)
    request.basic_auth '146507', 'oCwSHoEeVlZS'

    response = http.request(request)

    arr = JSON.parse(response.read_body)
    cost = Cost.new(cost1: arr['cost'], cost2: arr['cost'], cost3:arr['cost'], lastUpdate: 3)
    cost.save!
  end

end