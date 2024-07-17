require 'pg'

class Database
  attr_accessor :db_name, :db

  def initialize(db_name, user, password)
    @db_name = db_name
    @user = user
    @password = password
    db_connect
    create_table
    create_admin
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

  def create_table()
    tables = ["articles", "admin"]

    tables.each do |table_name|
      query_result = @db.exec(<<-SQL
        SELECT EXISTS (
        SELECT FROM pg_tables
        WHERE schemaname = 'public'
        AND tablename = "#{table_name}")
        SQL
      )
      tables_exists = query_result[0]['exists'] == 't'

      if tables_exists
        puts "Table alright exists"
      else
        if table_name == "articles"
        @db.exec( <<-SQL
          CREATE TABLE articles (
          id VARCHAR(255) UNIQUE,
          title VARCHAR(255) NOT NULL,
          content TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
          SQL
        )
        elsif table_name == "admin"
          @db.exec(<<-SQL
            CREATE TABLE admin (
            id VARCHAR(255) UNIQUE,
            email VARCHAR(255) NOT NULL UNIQUE,
            admin_password TEXT NOT NULL)
            SQL
          )
        end
      end
    end


  end

  def insert_data(title, content)
    @db.prepare('insert_article','
      INSERT INTO articles (id, title, content) VALUES ($1, $2, $3) RETURNING id'
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
