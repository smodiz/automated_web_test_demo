require 'capybara'
require 'capybara/rspec'
require 'capybara-webkit'
require 'selenium-webdriver'
require 'active_record'
require 'pg'
require 'yaml'
require 'pry'
require 'pry-byebug'
require 'database_cleaner'
require 'rest-client'
require 'json'

# Load the credentials
ENV.update YAML.load(File.read('./credentials.yml'))

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Capybara::DSL

  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each do |f|
    require "#{f}"
  end

  # use DatabaseCleaner to manage test data removal
  config.before(:each) do
    DatabaseCleaner.strategy =
      :truncation,
      { only: %w(decks tags taggings flash_cards) }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = ENV['QN_APP_HOST']

  # use :webkit for a headless driver, and :selenium for an actual browser
  config.default_driver = :selenium

  # By default, the javascript driver is selenium, but can be changed like this:
  # Capybara.javascript_driver = :webkit
end

# Set up test database connection
ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     ENV['DB_HOST'],
  database: ENV['DB_NAME'],
  username: ENV['DB_USER'],
  password: ENV['DB_PASSWORD'])

# Create the test user in the database, if not exists
user = User.where(email: ENV['QN_USER']).first
Pages::SignUp.new.sign_up unless user
