require_relative 'database'
require 'bcrypt'

class Admin

  def login
    email = request_params['email']
    password = request_params['password']

    admin = @db.exec("SELECT * FROM admin WHERE email = $1", [email])

    if admin.ntuples > 0

    else
      create
    end
  end

  def create
  end
end

class Customer

end
