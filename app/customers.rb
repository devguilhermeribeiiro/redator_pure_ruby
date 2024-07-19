require_relative 'database'
require 'bcrypt'

class Customer
  @db = Database.new('test_db', 'user_test', 'test123')

  def self.db
    @db
  end
end

