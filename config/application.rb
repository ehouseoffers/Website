require File.expand_path('../boot', __FILE__)

require 'yaml'
KEYS_TMP = YAML.load(File.read(File.expand_path('../keys.yml', __FILE__)))
APP_CONFIG = YAML.load(File.read(File.expand_path('../app_config.yml', __FILE__)))

require 'rails/all'

env = !Rails.env.blank? ? Rails.env.to_s : 'test'

KEYS = KEYS_TMP[env]

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
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # CSS/JavaScript files you want as :defaults
    config.action_view.stylesheet_expansions[:defaults] = %w(application)
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails application)

    config.generators do |g|
      g.template_engine :haml
    end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Mailer Config: see setup_mail.rb for mailing stuff
  end
end

# younker [2013-03-25 11:38] VERY quick paperclip fix.
# See https://github.com/thoughtbot/paperclip/issues/337
class ActionDispatch::Http::UploadedFile
  include Paperclip::Upfile
end
