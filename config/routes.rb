Rails.application.routes.draw do
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
    get 'application/healthCheck', to: 'application#health_check'
    get 'costs/calculate_cost', to: 'costs#calculate_cost'
    get 'costs/is_updated', to: 'costs#is_updated'
end
