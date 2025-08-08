# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Load support files (e.g. factory_bot.rb)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


# Ensure database schema is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Use fixtures if needed (can remove this if using FactoryBot only)
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # Run each example in a transaction (good for non-JS tests)
  config.use_transactional_fixtures = true

  # Automatically tag spec types based on file location
  config.infer_spec_type_from_file_location!

  # Clean backtraces from Rails internals
  config.filter_rails_from_backtrace!
  # config.filter_gems_from_backtrace("gem name")
end
