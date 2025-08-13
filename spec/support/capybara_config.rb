# Capybara configuration for system tests
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_chrome_headless)
  end

  # Configure Capybara for better test reliability
  Capybara.configure do |capybara_config|
    capybara_config.default_max_wait_time = 10
    capybara_config.default_normalize_ws = true
    capybara_config.ignore_hidden_elements = false
  end

  # Configure Selenium for Chrome headless with better driver management
  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new

    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1920,1080')
    options.add_argument('--disable-web-security')
    options.add_argument('--allow-running-insecure-content')

    # Use webdrivers gem for automatic driver management
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options,
      service: Selenium::WebDriver::Chrome::Service.new(
        args: [ '--verbose', '--log-path=/tmp/chromedriver.log' ]
      )
    )
  end

  # Fallback to rack_test if Chrome is not available
  config.before(:each, type: :system, js: true) do
    begin
      driven_by(:selenium_chrome_headless)
    rescue Selenium::WebDriver::Error::NoSuchDriverError
      puts "Chrome driver not available, falling back to rack_test"
      driven_by(:rack_test)
    end
  end
end
