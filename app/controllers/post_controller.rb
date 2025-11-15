require 'eredor'
require_relative '../mappers/post_mapper'

class PostController < Eredor::BaseController
  def index
    result = @post_mapper.all
    @posts = result.map do |row|
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
end
