require 'sqlite3'
require_relative 'database'

class Redator
  attr_accessor :title, :content

  def initialize(title, content)
    @title = title
    @content = content
    @db = Database.new('redator.db')
  end

  def create
    begin
      @db.insert_data(@title, @content)
    rescue SQLite3::SQLException => e
      puts "Erro ao inserir os dados no banco: #{e.message}"
    end
  end

  def self.read
    db = Database.new('redator.db')
    begin
      db.select_all_data.map do |row|
        new(row['id'], row['title'], row['content'], row['created_at'])
      end
    rescue SQLite3::SQLException => e
      puts "Erro ao consultar banco de dados: #{e.message}"
      []
    end
  end
end
