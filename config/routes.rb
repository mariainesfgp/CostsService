Rails.application.routes.draw do

    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'

    get 'costs/prueba', to: 'costs#prueba'
    get 'costs/calculate_cost', to:'costs#calculate_cost'
    get 'costs/is_updated', to:'costs#is_updated'
end
