require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade

  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)

  end

  def save

    if self.id
      self.update

    else

    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.name = name
    student.grade = grade
    student.save
    student

  end

  def self.new_from_db(row)
    # new = self.all.select { |array| array == row}
    # new.
    student = Student.new(row[1], row[2], row[0])
    # student.id = row[0]
    # # student.name = row[1]
    # # student.grade = row[2]
    student
  end

  def self.find_by_name(student_name)

    sql = <<-SQL
    SELECT * FROM students
    WHERE students.name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, student_name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end









end

#
# def self.new_from_db(name, grade, id=nil)
#   # create a new Student object given a row from the database
#   new_student = self.new  # self.new is the same as running Song.new
#   new_student.id = row[0]
#   new_student.name =  row[1]
#   new_student.grade = row[2]
#   new_student
# end
#
# def self.all
#
#   sql = <<-SQL
#     SELECT *
#     FROM students
#   SQL
#
#   DB[:conn].execute(sql).map do |row|
#     self.new_from_db(row)
#   end
# end
#
# def self.find_by_name(name)
#
#     sql = <<-SQL
#       SELECT *
#       FROM students
#       WHERE name = ?
#       LIMIT 1
#     SQL
#
#     DB[:conn].execute(sql, name).map do |row|
#       self.new_from_db(row)
#     end.first
#   end
#
#
# def save
#
#   sql = <<-SQL
#     INSERT INTO students (name, grade)
#     VALUES (?, ?)
#   SQL
#
#   DB[:conn].execute(sql, self.name, self.grade)
#
#   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
#
# end
#
# def self.create_table
#   sql = <<-SQL
#   CREATE TABLE IF NOT EXISTS students (
#     id INTEGER PRIMARY KEY,
#     name TEXT,
#     grade TEXT
#   )
#   SQL
#
#   DB[:conn].execute(sql)
# end
#
# def self.drop_table
#   sql = "DROP TABLE IF EXISTS students"
#   DB[:conn].execute(sql)
# end
#
# def self.create(name, grade)
#   student = self.new
#   student.name = name
#   student.grade = grade
#   student.save
#   student
# end
#
#
