# frozen_string_literal: true

require 'rack'
require_relative 'config/database'
require_relative 'controllers/*'
require 'eredor'

class App
  def call(env)
    request = Rack::Request.new(env)
    router = Eredor::Router.new(request)

    router.get '/posts' do |params|
      PostController.new(params).index
    end

    router.get '/admin' do |params|
      AdminController.new(params).login
    end
  end
end
