require 'pg'


# select * from admin;
# verificar se exite admin já criado, se sim redirecionar pro login se não pra criação de conta



class Database
  attr_accessor :db_name, :db

  def initialize(db_name, user, password)
    @db_name = db_name
    @user = user
    @password = password
    db_connect
    create_table
    # create_admin
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
    @db.exec( <<-SQL
    CREATE TABLE IF NOT EXISTS articles (
      id VARCHAR(255) UNIQUE,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
      SQL
    )
    @db.exec(<<-SQL
      CREATE TABLE IF NOT EXISTS admin (
      id VARCHAR(255) UNIQUE,
      admin_email VARCHAR(255) NOT NULL UNIQUE,
      admin_password TEXT NOT NULL)
      SQL
    )
  end

  def create_admin(id, email, admin_password)
    @db.prepare('insert_admin','
      INSERT INTO admin (id, admin_email, admin_password) VALUES ($1, $2, $3)'
    )
    @db.exec_prepared('insert_admin', [id, email, admin_password])
  end

  def insert_data(id, title, content)
    @db.prepare('insert_article','
      INSERT INTO articles (id, title, content) VALUES ($1, $2, $3) RETURNING id'
    )
    @db.exec_prepared('insert_article', [id, title, content])
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
