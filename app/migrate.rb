def db_migrate
  db.exec <<-SQL
    CREATE TABLE IF NOT EXISTS articles (
      id VARCHAR(255) UNIQUE,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  SQL

  db.exec <<-SQL
    CREATE TABLE IF NOT EXISTS admin (
      id VARCHAR(255) UNIQUE,
      admin_email VARCHAR(255) NOT NULL UNIQUE,
      admin_password TEXT NOT NULL
    );
  SQL
end
