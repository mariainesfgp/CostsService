if Rails.env.development?
  ENV['user']='hola'
  ENV['password'] = 'hola'
  ENV['URICost'] = 'https://delivery-rates.mybluemix.net/cost'
  ENV['URIAreas']='https://delivery-rates.mybluemix.net/areas'
  ENV['AuthDeliveryRateAccount'] = '146507'
  ENV['AuthDeliveryRatePassword'] = 'oCwSHoEeVlZS'
  ENV['URIDeliveryRates'] = 'https://delivery-rates.mybluemix.net/'

end