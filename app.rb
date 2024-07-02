require 'erb'
require_relative 'database'

class Redator
  def initialize
    @conn = Database.conection
  end

  def self.all
    puts "funcionou"
  end
end
