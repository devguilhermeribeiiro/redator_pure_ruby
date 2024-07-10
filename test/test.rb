class Post
  attr_accessor :id, :title, :content, :created_at

  def initialize(title, content)
    @title = title
    @content = content
  end

  def asdf
    @title
  end

  def id
    15
  end
end

class Database
  def select_all_data
    [
      {'id' => 1, 'title' => 'First Post', 'content' => 'This is the first post', 'created_at' => '2023-01-01'},
      {'id' => 2, 'title' => 'Second Post', 'content' => 'This is the second post', 'created_at' => '2023-01-02'}
    ]
  end

  def id
    15
  end
end

db = Post.new('asdf-', 'qert')

puts db.asdf
puts db.id

# posts = db.select_all_data.map do |row|
#   Post.new(row['title'], row['content']).tap do |post|
#     post.id = row['id']
#     post.created_at = row['created_at']
#   end
# end

# # `posts` agora contém uma array de objetos `Post` completamente inicializados
# puts posts[0].id
