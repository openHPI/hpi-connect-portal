Airbrake.configure do |config|
  config.api_key = '605cfbede04b4bbe5da264e22c8bb8e3'
  config.host    = 'swt2-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end