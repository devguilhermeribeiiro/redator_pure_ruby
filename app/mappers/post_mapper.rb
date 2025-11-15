class PostMapper < Eredor::DataMapper
  def set_table_name
    @table_name = 'posts'
  end
end
