class Test
  attr_accessor :new_table
  def initialize(new_table)
    @new_table = new_table
    @table_name = @new_table[:table_name]
    @table_params = @new_table[:table_params]
  end
  def create_table
    puts "CREATE TABLE IF NOT EXISTS #{@table_name} (
    id SERIAL PRIMARY KEY,
    #{@table_params.keys[0]} VARCHAR(255) NOT NULL,
    #{@table_params.keys[1]} VARCHAR (255) NOT NULL UNIQUE,
    #{@table_params.keys[2]} VARCHAR (255) NOT NULL,
    )"
  end
end

a = {table_name: 'users', table_params: {full_name: 'John Snow', email: 'john@snow', password: 'johntargeryan'}}

test = Test.new(a)
test.create_table
