require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  url = ENV["SELENIUM_DRIVER_URL"]
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('remote-debugging-port=9222')
  options.add_argument('window-size=950, 800')

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: url,
                                 capabilities: options)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3001
    Capybara.app_host = "http://web:3001"
  end
end
