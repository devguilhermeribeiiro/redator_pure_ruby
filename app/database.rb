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
      INSERT INTO articles (title, content) VALUES ($1, $2) RETURNING id'
    )
    @db.exec_prepared('insert_article', [title, content])
  end

  def select_all_data
    @db.exec('SELECT * FROM articles')
  end

  def select_article_by_id(id)
    @db.exec_params('SELECT * FROM articles WHERE id = $1', [id])
  end

  def update_article_by_id(title, content, id)
  @db.exec_params('UPDATE articles SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def destroy_article_by_id(id)
    @db.exec_params('DELETE FROM articles WHERE id = $1', [id])
  end
end
