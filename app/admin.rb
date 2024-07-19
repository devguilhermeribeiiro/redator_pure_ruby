require_relative 'database'
require 'bcrypt'

class Admin

  @db = Database.new('test_db', 'user_test', 'test123')

  def self.db
    @db
  end

  def self.login(email, password)
    begin
      admin_password = db.select_admin(email)

      if admin_password.ntuples > 0
        stored_password = admin_password[0]['admin_password']
        hashed_password = BCrypt::Password.new(stored_password)
        hashed_password == password
      else
        false
      end
    rescue PG::Error => e
      puts "Algo deu errado ao tentar fazer o login #{e}"
      false
    end
  end


    def self.create
    end
  end
