require 'eredor'
require_relative '../mappers/post_mapper'

class PostController < Eredor::BaseController
  def index
    @posts = @post_mapper.all.map do |row|
      {
        id: row['id'],
        title: row['title'],
        description: row['description'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
      }
    end

    render('index')
  end

  def show
    result = @post_mapper.where(id: params[:id].to_i)
    @post = {}

    result.each do |row|
      row.each_pair do |key, value|
        @post[key.to_sym] = value
      end
    end

    render('show')
  end
end
