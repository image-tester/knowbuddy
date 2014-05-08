# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
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
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include SunspotMatchers
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def fetch_activity_type(type)
  ActivityType.where(activity_type: type, is_active: true).first_or_create
end
