require_relative 'database'
require 'bcrypt'
require 'securerandom'

class Admin
  @db = Database.new('test_db', 'user_test', 'test123')
  
  def self.db
    @db
  end

  def self.login(email, password)
    admin_password = db.select_admin(email)
    begin
      if admin_password.ntuples.positive?
        stored_password = admin_password[0]['admin_password']
        hashed_password = BCrypt::Password.new(stored_password)
        hashed_password == password
      else
        false
      end
    rescue PG::Error => e
      puts "Algo deu errado ao tentar fazer o login #{e.message}"
      false
    end
  end

  def self.exists(email, password)
    exists_admin = db.exists_admin
    puts "Exists admin #{exists_admin}"
    begin
      if exists_admin
        login(email, password)
      else
        id = SecureRandom.uuid
        admin_password = BCrypt::Password.create(password)
        db.create_admin(id, email, admin_password)
        login(email, password) 
      end
    rescue PG::Error => e
      puts "Algo deu errado ao tentar criar o admin #{e.message}"
    end
  end
end
