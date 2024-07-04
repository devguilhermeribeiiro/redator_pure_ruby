require 'sqlite3'
require_relative 'database'

class Redator
  attr_accessor :title, :content, :id, :created_at

  @db = Database.new('redator.db')

  def initialize(title, content)
    @title = title
    @content = content
  end

  def create
    begin
      self.class.db.insert_data(@title, @content)
    rescue SQLite3::SQLException => e
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
    rescue SQLite3::SQLException => e
      puts "Erro ao consultar banco de dados: #{e.message}"
      []
    end
  end

  def self.db
    @db
  end
end

