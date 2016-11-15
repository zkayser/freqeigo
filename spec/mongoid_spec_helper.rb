ENV['RAILS_ENV'] ||= 'test'

RSpec.configure do |config|
  #Purge database in test environment to maintain cleanliness and run faster
  if ENV['RAILS_ENV'] == 'test'
    config.before(:each) { Mongoid.purge! }
  else
    require 'database_cleaner'
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end
    config.before(:each) { DatabaseCleaner.clean }
  end
end