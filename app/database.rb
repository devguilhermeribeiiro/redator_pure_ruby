require 'pg'

class Database
  attr_accessor :db_name, :db

  def initialize(db_name, user, password)
    @db_name = db_name
    @user = user
    @password = password
    db_connect
    create_table
  end

  def db_connect
    @db = PG.connect(
      dbname: @db_name,
      user: @user,
      password: @password,
      host: 'localhost',
      port: 5432
    )
    @db.type_map_for_results = PG::BasicTypeMapForResults.new(@db)
  end

  def create_table
    @db.exec( <<-SQL
      CREATE TABLE IF NOT EXISTS articles (
      id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
      SQL
    )
  end

  def insert_data(title, content)
    @db.prepare('insert_article','
      INSERT INTO articles (title, content) VALUES ($1, $2)'
    )
    @db.exec_prepared('insert_article', [title, content])

  end

  def select_all_data
    @db.exec('SELECT * FROM articles')
  end
end
