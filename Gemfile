source "https://rubygems.org"

ruby "~> 3.4.5" # Optional: locks to a known-good version

# Rails core
gem "rails", "~> 8.0.2"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "propshaft" # asset pipeline

# Asset bundling
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"

# JSON support
gem "jbuilder"

# Authentication
gem "bcrypt", "~> 3.1.7"

# Modern background tools (Rails 8)
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Optional deployment & performance tools
gem "kamal", require: false
gem "thruster", require: false

# Required in config/boot.rb
gem "bootsnap", require: false

# Optional debugging tools
gem "pry-rails"

# Optional image processing (uncomment if needed)
# gem "image_processing", "~> 1.2"

# Windows time zone support
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Security + Linting
  gem "brakeman", require: false
  gem "erb_lint", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Testing
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
  gem "simplecov", require: false
end
