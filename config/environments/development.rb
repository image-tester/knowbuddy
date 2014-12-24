Rails.application.configure do
  # Settings specified here will take precedence over those
  # in config/application.rb
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  # Log error messages when you accidentally call methods on nil.
  # config.whiny_nils = true
  config.eager_load = false
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  # Only use best-standards-support built into browsers
  # config.action_dispatch.best_standards_support = :builtin
  config.active_record.migration_error = :page_load
  # Do not compress assets
  # config.assets.compress = false
  config.assets.digest = true
  # Expands the lines which load the assets
  config.assets.debug = true
  config.assets.raise_runtime_errors = true
  # Added by Rohan on 12-Mar-2012 to provide smtp host for sending
  # emails from this portal
  # START
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: APP_CONFIG["host"] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
  Paperclip.options[:command_path] = "/usr/local/bin/"
  # END
end

