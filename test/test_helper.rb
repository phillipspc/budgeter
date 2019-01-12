ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'bcrypt'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def this_month
    Time.now.strftime("%B %Y")
  end

  def last_month
    (Time.now. - 1.month).strftime("%B %Y")
  end
end
