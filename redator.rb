require 'erb'
require_relative 'database'

class Redator
  attr_accessor :title, :content

  def initialize(title, content)
    @title = title
    @content = content
  end

  def create
    begin
      conn = Database.connection
      conn.exec_params('
      INSERT INTO artigos (title, content)
      VALUES ($1, $2)', [@title, @content])
    rescue => database_insertion_error
      puts "Erro ao inserir os dados no banco: #{database_insertion_error.message}"
    ensure
      conn.close if conn

    end
  end

  def self.read
    begin
      conn = Database.connection
      query = conn.exec('SELECT * FROM artigos')
      posts = query.map do |row|
        new(row['title'], row['content'])
      end
      posts
    rescue => database_connection_error
      puts "Erro ao consultar banco de dados: #{database_connection_error.message}"
      []
    ensure
      conn.close if conn
    end
  end
end
