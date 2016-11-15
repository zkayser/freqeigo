# Got this from the Devise documentation
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end