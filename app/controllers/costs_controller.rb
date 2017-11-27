class CostsController < ApplicationController
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == ENV['user'] && password == ENV['password']
    end
  end

  def calculate_cost
    longitude_from = params[:longitude_from]
    latitude_from = params[:latitude_from]
    longitude_to = params[:longitude_to]
    latitude_to = params[:latitude_to]
    weight = params[:weight]

    estimated_price = false

    zone_from = Zone.get_zone(latitude_from,longitude_from)
    zone_to = Zone.get_zone(latitude_to, longitude_to)

    aux_cost_weight = Cost.where(["id = 1"]).first

    cost_weight = 0
    cost_zone = 0
    if(aux_cost_weight.updated_at < 10.minutes.ago)
      #Case 1 : estimated price
      estimated_price = true
      cost_weight = (aux_cost_weight.cost1 + aux_cost_weight.cost2 + aux_cost_weight.cost3) / 3
    else
      cost_weight= Cost.get_cost_weight(aux_cost_weight)
    end

    if (zone_from==zone_to)
      cost_zone = 0
    else
      aux_cost_zone = Costzone.where(["\"zoneFrom\" = ? and \"zoneTo\" = ?", zone_from, zone_to]).first
      if(aux_cost_zone.updated_at < 10.minutes.ago)
        estimated_price=true
        cost_zone = (aux_cost_zone.cost1 + aux_cost_zone.cost2 + aux_cost_zone.cost3) / 3
      else
        cost_zone = Costzone.get_cost_zone(aux_cost_zone)
      end
    end
    cost = ((weight.to_i * cost_weight) + cost_zone).round(2)
    render :json => {:cost => cost, :estimatedPrice => estimated_price}
  end

  def is_updated
    updated = true
    cost_weight = Cost.where(["id = 1"]).first
    cost_zones = Costzone.where(["id = 1"]).first
    if cost_zones.updated_at < 10.minutes.ago && cost_weight.updated_at < 10.minutes.ago
      updated = false
    end
    render :json => {:updated => updated}
  end

end