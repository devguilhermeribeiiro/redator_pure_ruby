require 'rack'
require 'pg'
require_relative 'app'
#require 'routes.rb'
require_relative 'database'

Database.connect
  
class App 
  
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/' 
      Redator.all
    #when 'new'
     # new_redactions
    end
  end
end

run App.new
