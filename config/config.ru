# frozen_string_literal: true

require 'rack'
require_relative '../app/app'

use Rack::Static, urls: ['/css', '/js', '/images'], root: 'src'

run App.new
