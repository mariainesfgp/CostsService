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

    zone_from = get_zone(longitude_from,latitude_from)
    zone_to = get_zone(longitude_to, latitude_to)

    aux_cost_weight = Cost.where(["id = 1"]).first

    cost_weight = 0
    cost_zone = 0
    if(aux_cost_weight.updated_at < 10.minutes.ago)
      #Case 1 : estimated price
      estimated_price = true
      cost_weight = (aux_cost_weight.cost1 + aux_cost_weight.cost2 + aux_cost_weight.cost3) / 3
    else
      cost_weight= get_cost_weight(auxCostWeight)
    end

    if (zone_from==zone_to)
      cost_zone = 0
    else
      aux_cost_zone = Costzone.where(["\"zoneFrom\" = ? and \"zoneTo\" = ?", zone_from, zone_to]).first
      if(aux_cost_zone.updated_at < 10.minutes.ago)
        estimated_price=true
        cost_zone = (aux_cost_zone.cost1 + aux_cost_zone.cost2 + aux_cost_zone.cost3) / 3
      else
        cost_zone = get_cost_zone(aux_cost_zone)
      end
    end
    cost = ((weight.to_i * cost_weight) + cost_zone).round(2)
    render :json => {:cost => cost, :estimatedPrice => estimated_price}
  end

  def get_zone lat, long
    sql = 'SELECT * FROM zones WHERE st_contains(ST_GeomFromText(zones.polygon), ST_GeomFromText(?))'
    point = 'POINT('+lat+''+long+')'
    zone = Zone.find_by_sql([sql, point]).first.identify.to_i
    zone
  end

  def get_cost_weight aux_cost_weight
    if(aux_cost_weight.lastUpdate==1)
      cost_weight = auxCostWeight.cost1
    else if(aux_cost_weight.lastUpdate == 2)
           cost_weight = aux_cost_weight.cost2
         else
           cost_weight = aux_cost_weight.cost3
         end
    end
    cost_weight
  end

  def get_cost_zone aux_cost_zone
    if(aux_cost_zone.lastUpdate==1)
      cost_zone = aux_cost_zone.cost1
    else if(aux_cost_zone.lastUpdate == 2)
           cost_zone = aux_cost_zone.cost2
         else
           cost_zone = aux_cost_zone.cost3
         end
    end
    cost_zone
  end

  def is_updated
    updated = true
    cost_weight = Cost.where(["id = 1"]).first
    cost_zones = Costzone.where(["id = 1"]).first
    if cost_zones.updated_at>10.minutes.ago && cost_weight.updated_at>10.minutes.ago
      updated = false
    end
    render :json => {:updated => updated}
  end

  def prueba
    render :json => {:ok => true}
  end
end