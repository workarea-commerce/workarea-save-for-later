require_relative 'boot'

require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"
require 'teaspoon-mocha'


# Workarea must be required before other gems to ensure control over Rails.env
# for running tests
require 'workarea/core'
require 'workarea/admin'
require 'workarea/storefront'
Bundler.require(*Rails.groups)
require "workarea/save_for_later"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
