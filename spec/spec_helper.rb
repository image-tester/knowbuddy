# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'faker'
require 'sunspot'
require 'sunspot_matchers'
require 'sunspot/rails/spec_helper'
require 'capybara/rspec'
require 'public_activity/testing'
# Requires supporting ruby files with custom matchers and macros, etc,

# in spec/support/ and its subdirectories.
 Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

PublicActivity.enabled = true

RSpec.configure do |config|

  config.include SunspotMatchers
  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Capybara::DSL

  include Warden::Test::Helpers
  Warden.test_mode!

  Capybara.default_wait_time = 5

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.filter_run_excluding :broken => true
end

def fetch_activity_type(type)
  ActivityType.where(activity_type: type, is_active: true).first_or_create
end

def find_activity(user, key)
  PublicActivity::Activity.find_by_owner_id_and_key(user.id, key)
end
