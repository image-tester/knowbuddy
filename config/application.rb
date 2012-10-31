require File.expand_path('../boot', __FILE__)
require 'rails/all'
if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(assets: %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end
module KYU
  class Application < Rails::Application
    # Settings in config/environments/*
    # take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Custom directories with classes and modules you want to be autoloadable.
     config.autoload_paths += %W(#{config.root}/lib/jobs)
    # Only load the plugins named here,
    # in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    # Activate observers that should always be running.
    # config.active_record.observers = :cacher,
    # :garbage_collector, :forum_observer
    # Set Time.zone default to the specified zone and
    # make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # The default locale is :en and all translations
    # from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.
    # join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    # Enable the asset pipeline
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'
    # Added by Rohan on 04-Mar-2012
    # Start
    #config.assets.paths << "#{Rails.root}/public/assets/fonts"
    #config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
    #config.assets.paths << Rails.root.join("app", "assets", "javascripts")
    # End
    #Added by Rohan on 03-Mar-2012
    #Start Add
    config.to_prepare do
          Devise::PasswordsController.layout "sign"
          Devise::SessionsController.layout "sign"
          Devise::RegistrationsController.layout "sign"
    end
    #End Add
    # Added by yatish on 09-May-2012 for observer
    # Start
    config.active_record.observers = :auditor_observer
    #end
    config.active_record.whitelist_attributes = true
    # Added to display inline all rails validation error messages
    # Start
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      unless html_tag =~ /^<label/
        %{#{html_tag}<div class = "profile_form_error"><label for="#{instance.send(:tag_id)}" class="profile_msg">#{instance.error_message.first}</label></div>}.html_safe
      else
        %{#{html_tag}}.html_safe
      end
    end
    # End
  end
end

