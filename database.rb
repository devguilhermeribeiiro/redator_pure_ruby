require 'pg'

class Database
  def self.connect
    begin
      @conn = PG.connect(
        dbname: 'redator_ruby_development',
        user: 'guilherme',
        password: 'guilherme:20032013',
        host: 'localhost',
        port: 5431
      )
      puts "Connected successfuly"
    rescue PG::Error => exception
    puts "Connection error: #{exception.message}"
    end
  end

  def self.conection
    @conn
  end
end
