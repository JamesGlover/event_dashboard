ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl_rails'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...

  include FactoryGirl::Syntax::Methods

end
