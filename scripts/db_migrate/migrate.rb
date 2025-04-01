# frozen_string_literal: true

require 'securerandom'
require 'dotenv/load'
require 'bcrypt'
require_relative '../../app/database'

class Migrate
  def self.db
    @db = Database.new
  end

  def self.create_tables
    db.query <<-SQL
      CREATE TABLE IF NOT EXISTS articles (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    db.query <<-SQL
      CREATE TABLE IF NOT EXISTS admin (
        id UUID PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
    SQL

    db.create_admin(SecureRandom.uuid, ENV['admin_email'], BCrypt::Password.create(ENV['admin_password']))
  end
end

Migrate.create_tables
