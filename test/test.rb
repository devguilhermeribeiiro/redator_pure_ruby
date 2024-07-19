require 'securerandom'

# class Test
#   attr_accessor :name, :age

#   def initialize(name, age)
#     @name = name
#     @age = age
#   end

#   def hello
#     puts "Hello #{@name}, your age is #{@age}"
#   end
# end

# Test.new('Guilherme', '21').hello


1.times do
  i = SecureRandom.uuid
  1.times do
    j = SecureRandom.uuid
    a = j + i
    1.times do
      k = SecureRandom.uuid
      b = k + a
      puts i
      puts j
      puts k
      puts a
      puts b
    end
  end
end
