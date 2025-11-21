# frozen_string_literal: true

Dir[File.join(__dir__, 'controllers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'mappers', '*.rb')].each { |file| require file }

require 'rack'
require 'eredor'

class App
  def initialize
    @post_mapper = PostMapper.new(Eredor::PostgresDatabase.connect)
  end

  def call(env)
    request = Rack::Request.new(env)
    router = Eredor::Router.new(request)

    router.get '/' do
      '<h1 style="font-family: Arial;">Hello World</h1>'
    end

    router.get '/posts' do |params|
      PostController.new(params, @post_mapper).index
    end

    router.get '/posts/:id' do |params|
      PostController.new(params, @post_mapper).show
    end

    router.handle
  end
end
