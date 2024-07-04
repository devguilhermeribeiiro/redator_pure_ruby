require 'sqlite3'

class Database
  attr_accessor :db_name, :db

  def initialize(db_name)
    @db_name = db_name
    create_db
    create_table
  end

  def create_db
    @db = SQLite3::Database.new "#{@db_name}"
    @db.results_as_hash = true
  end

  def create_table
    @db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS articles (
      id INTEGER PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
    SQL
  end

  def insert_data(title, content)
    @db.execute('
      INSERT INTO articles (title, content)
      VALUES (?, ?)', [title, content]
    )
  end

  def select_all_data
    @db.execute('SELECT * FROM articles')
  end
end
