# frozen_string_literal: true

system('bundle i')
system('puma -C config/puma.rb')
