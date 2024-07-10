require_relative '../app/app.rb'
require 'rack'


use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "public"

run App.new
