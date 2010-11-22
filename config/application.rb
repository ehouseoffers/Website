require File.expand_path('../boot', __FILE__)

require 'rails/all'

env = !Rails.env.blank? ? Rails.env.to_s : 'test'

Rails.logger.info("----------------------------- application.rb:7 - Rails.root.to_s = '#{Rails.root.to_s.inspect}'")
Rails.logger.info("----------------------------- application.rb:8 - env = '#{env.inspect}'")

raw_config = File.read(Rails.root.to_s + "config/keys.yml")
KEYS = YAML.load(raw_config)[env]

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Ehouseoffers
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # CSS/JavaScript files you want as :defaults
    config.action_view.stylesheet_expansions[:defaults] = %w(application)

    # This is NOT actually working. WTF?
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails application jquery.growl)

    config.generators do |g|
      g.template_engine :haml
    end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # config.action_mailer.default_charset = "utf-8"
    #     config.action_mailer.delivery_method = :smtp
    #     config.action_mailer.smtp_settings   = {
    #       :address        => "smtp.webfaction.com",
    #       :authentication => :login,
    #       :domain         => "webfaction.com",
    #       :port           => 25,
    #       :user_name      => KEYS['email']['mailbox_username'],
    #       :password       => KEYS['email']['mailbox_password']
    #     }

  end
end
