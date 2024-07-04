require 'pg'

class Database
  def self.connect
    begin
      @conn = PG.connect(
        dbname: 'redator',
        user: 'ruby',
        password: 'ruby:2024',
        host: 'localhost',
        port: 5432
      )
      @conn.exec('CREATE TABLE IF NOT EXISTS artigos
        (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        content TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )'
      )
      puts "Connected successfuly"
    rescue PG::Error => exception
    puts "Connection error: #{exception.message}"
    end
  end

  def self.connection
    @conn
  end
end
