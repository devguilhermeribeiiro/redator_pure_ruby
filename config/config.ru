# frozen_string_literal: true

require 'rack'
require 'rack/session/cookie'
require 'dotenv/load'
require_relative '../app/app'

use Rack::Static, urls: ['/css', '/js', '/images'], root: 'src'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: ENV['SECRET']

run App.new
