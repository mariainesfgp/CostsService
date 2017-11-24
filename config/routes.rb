Rails.application.routes.draw do
    get 'costs/prueba', to: 'costs#prueba'
    get 'costs/calculate_cost', to:'costs#calculate_cost'
    get 'costs/is_updated', to:'costs#is_updated'
end
