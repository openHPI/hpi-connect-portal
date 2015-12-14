Airbrake.configure do |config|
  config.api_key = '2ebc745c6db0704bc856ce1f8f3abb65'
  config.host    = 'swt2-2015-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end