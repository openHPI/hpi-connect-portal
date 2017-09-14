Airbrake.configure do |config|
  config.host = 'https://hpi-connect-errbit.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = '8fbd8602b54c6c26bf714bfb7b810c37'

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
