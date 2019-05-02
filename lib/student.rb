require 'pry'
require_relative "../config/environment.rb"

class Student

  def self.create_table
    DB[:conn].execute(<<-SQL)
    CREATE TABLE students(
      name TEXT,
      grade TEXT,
      id INTEGER PRIMARY KEY
    );
    SQL
  end

  def self.drop_table
    DB[:conn].execute(<<-SQL)
    DROP TABLE IF EXISTS students
    SQL
  end

  def self.create(name, grade)
    stu = Student.new(name, grade)
    stu.save
  end

  def self.new_from_db(row)
    id, name, grade = row[0], row[1], row[2]
    stu = Student.new(name, grade, id)
    # binding.pry
  end

  def self.find_by_name(name)
    all.find { |student| student.name == name }
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    if id
      update
    else
      sql = <<-SQL
      INSERT INTO 
        students(name, grade)
      VALUES
        (?, ?)
      SQL
      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
    UPDATE
      students
    SET
      name = ?,
      grade = ?
    WHERE
      id = ?
    SQL
    DB[:conn].execute(sql, self.name, grade, id)
  end

  private

  def self.all
    sql = <<-SQL
    SELECT
      *
    FROM
      students
    SQL
    DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

end
