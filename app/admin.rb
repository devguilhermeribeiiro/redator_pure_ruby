# frozen_string_literal: true

require_relative 'database'
require 'bcrypt'
require 'securerandom'

# Login class
class Admin
  def self.db
    @db = Database.new
  end

  def self.login(email, password)
    admin_password = db.select_admin(email)
    begin
      if admin_password.ntuples.positive?
        stored_password = admin_password[0]['password']
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
end
