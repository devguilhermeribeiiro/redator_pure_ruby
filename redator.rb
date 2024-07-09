require 'pg'
require_relative 'database'

class Redator
  attr_accessor :title, :content, :id, :created_at

  @db = Database.new('test_db', 'user_test', 'test123')

  def initialize(title, content)
    @title = title
    @content = content
  end

  def create
    begin
      self.class.db.insert_data(@title, @content)
    rescue PG::Error => e
      puts "Erro ao inserir os dados no banco: #{e.message}"
    end
  end

  def self.read
    begin
      db.select_all_data.map do |row|
        new(row['title'], row['content']).tap do |post|
          post.id = row['id']
          post.created_at = row['created_at']
        end
      end
    rescue PG::Error => e
      puts "Erro ao consultar banco de dados: #{e.message}"
    end
  end

  def self.db
    @db
  end
end
