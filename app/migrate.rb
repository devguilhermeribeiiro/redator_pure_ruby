# frozen_string_literal: true

def db_migrate
  @db.exec <<-SQL
    CREATE TABLE IF NOT EXISTS articles (
      id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  SQL

  @db.exec <<-SQL
    CREATE TABLE IF NOT EXISTS admin (
      id UUID PRIMARY KEY,
      email VARCHAR(255) NOT NULL UNIQUE,
      password TEXT NOT NULL
    );
  SQL
end
