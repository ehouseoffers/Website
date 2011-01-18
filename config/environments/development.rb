Ehouseoffers::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # younker [2010-11-15 10:18]
  # Why did I have this here? When it is 'http://localhost:3000', it totally
  # busts IE and when I hardcode the IP, well, it busts when the ip changes.
  # So why did I have this here for development? Can it be removed?
  # config.action_controller.asset_host = "http://localhost:3000"

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

