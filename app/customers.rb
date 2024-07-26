require_relative 'database'
require 'bcrypt'
require 'securerandom'

class Customer
  @db = Database.new('test_db', 'user_test', 'test123')

  def self.db
    @db
  end

  def self.login(email, password) 
    customer_password = db.select_customer(email)
    begin
      if customer_password.ntuples.positive?
        stored_password = customer_password[0]['customer_password']
        hashed_password = BCrypt::Password.new(stored_password)
        hashed_password.eql?(password)
      else
        false
      end
    rescue PG::Error => e
      puts "Algo deu errado ao tentar fazer login. #{e.message}"
    end
  end

  def self.exists(email, password)
    exists_customer = db.exists_customer
    puts "Exists customer #{exists_customer}"
    begin
      if exists_customer
        login(email, password)
      else
        id = SecureRandom.uuid
        customer_password = BCrypt::Password.create(password)
        db.create_customer(id, email, customer_password)
        login(email, password)
      end
    rescue PG::Error => e
      puts "Algo deu errado ao tentar criar o customer. #{e.message}"
    end
  end
end

