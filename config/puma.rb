#../config/puma.rb

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port        ENV.fetch("PORT") { 3030 }

environment ENV.fetch("RACK_ENV") { "development" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app!

rackup "config/config.ru"

plugin :tmp_restart
