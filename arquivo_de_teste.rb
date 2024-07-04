require_relative 'database'


class Teste
  @a = Database.new('teste.db')

  def self.asdf
    @a.create_db

  end
end


a = Teste.asdf
