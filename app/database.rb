require 'pg'
require 'securerandom'
require 'bcrypt'

module Admin_query

  def exists_admin
    query = @db.exec('SELECT COUNT(*) FROM admin')
    result_query = query[0]['count'].to_i
    exists = result_query.positive?
  end

  def create_admin(id, email, admin_password)
    @db.exec_params('INSERT INTO admin (id, email, admin_password)
      VALUES ($1, $2, $3)',[id, email, admin_password]
    )
  end

  def select_admin(email)
    @db.exec_params("SELECT admin_password FROM admin WHERE email = $1", [email])
  end
end

module Customer_query
  def exists_customer 
    query = @db.exec('SELECT COUNT(*) FROM customers')
    result_query = query[0]-['count'].to_i
    exists = result_query.positive?
  end

  def create_admin(id, email, customer_password)
  @db.exec_params('INSERT INTO customers (id, customer_email, customer_password)
    VALUES ($1, $2, $3)', [id, email, customer_password]
  )
  end

  def select_customer(email)
  @db.exec_params('SELECT customer_password FROM customers WHERE email = $1', [email])
  end
end

module Article_query

  def insert_data(title, content)
    @db.exec_params('INSERT INTO articles (title, content)
      VALUES ($1, $2) RETURNING id',[title, content]
    )
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

class Database

  include Admin_query
  include Customer_query
  include Article_query

  attr_accessor :db_name, :db

  def initialize(db_name, user, password)
    @db_name = db_name
    @user = user
    @password = password
    db_connect
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
end
