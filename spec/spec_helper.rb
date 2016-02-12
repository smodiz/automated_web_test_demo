require 'capybara'
require 'capybara/rspec'
require 'capybara-webkit'
require 'selenium-webdriver'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = 'http://localhost:3001/'

  # webkit is a headless driver, selenium opens an actual browser
  config.default_driver = :selenium
  # config.default_driver = :webkit

  # By default, the javascript driver is selenium, but can be changed
  # Capybara.javascript_driver = :webkit
end
