require 'pg'
require_relative 'database'
require 'securerandom'

class Article
  attr_accessor :title, :content, :id, :created_at

  def self.db
    @db = Database.new
  end

  def initialize(title, content)
    @title = title
    @content = content
  end

  def self.all
    begin
      db.select_all_data.map do |row|
        new(row['title'], row['content']).tap do |post|
          post.id = row['id']
          post.created_at = row['created_at'].strftime('%d-%m-%Y')
        end
      end
    rescue PG::Error => e
      puts "Erro ao consultar banco de dados: #{e.message}"
    end
  end

  def create
    begin
      result = self.class.db.insert_data(@title, @content)
      if result.any?
        @id = result.first['id']
      end
    rescue PG::Error => e
      puts "Erro ao inserir os dados no banco: #{e.message}"
    end
  end

  def self.read(id)
    begin
      result = db.select_article_by_id(id)
      if result.any?
        row = result.first
        new(row['title'], row['content']).tap do |post|
          post.id = row['id']
          post.created_at = row['created_at'].strftime('%d-%m-%Y')
        end
      else
        nil
      end
    rescue PG::Error => e
      puts "Erro ao consultar o banco de dados: #{e.message}"
    end
  end

  def self.update(title, content, id)
    begin
      db.update_article_by_id(title, content, id)
    rescue PG::Error => e
      puts "Erro ao atualizar artigo: #{e.message}"
    end
  end

  def self.destroy(id)
    begin
      db.destroy_article_by_id(id)
    rescue PG::Error => e
      puts "Erro ao deletar arquivo: #{e.message}"
    end

  end

end
