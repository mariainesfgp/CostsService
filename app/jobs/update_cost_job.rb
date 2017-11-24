require 'uri'
require 'net/http'
class UpdateCostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Start Update"
    Cost.update_cost
    Costzone.update_cost_zones
    puts "End Update"
  end
end
