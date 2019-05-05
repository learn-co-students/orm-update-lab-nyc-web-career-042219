require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_reader :grade
  attr_accessor :id, :name
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id= nil, name, grade)
    @id = id
    @name= name
    @grade = grade

  end

  def save

    sql= <<-SQL
      SELECT * FROM students WHERE students.id = ?
      SQL

      studentrow=DB[:conn].execute(sql, @id).first


    if studentrow == nil

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES ("#{self.name}", "#{self.grade}")
    SQL
  else
    # binding.pry

    sql = <<-SQL
      UPDATE students
      SET grade = "#{self.grade}", name = "#{self.name}"
      WHERE id = #{self.id}
    SQL
  end
  #  binding.pry
      DB[:conn].execute(sql)


      rowid=DB[:conn].last_insert_row_id

    #  puts "studnet: #{self.class.all}"
    #  binding.pry
      self.id=rowid

  end
def self.find_by_name(name)

  sql= <<-SQL
    SELECT * FROM students WHERE students.name = ?
    SQL

    studentrow=DB[:conn].execute(sql, name).first
    # binding.pry
    if studentrow == nil
        student_inst = nil
      else
        student_inst=self.new_from_db(studentrow)
      end
      #binding.pry
        student_inst


  # find the student in the database given a name
  # return a new instance of the Student class
end

def self.all

    sql=<<-SQL
      SELECT * FROM students
    SQL
    studentarr=DB[:conn].execute(sql)
    studentarr.map do |row|
      self.new_from_db(row)

    end


    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

  end

def self.new_from_db(row)
  id = row[0]
  name= row[1]
  grade=row[2]
  newstudent=Student.new(id, name, grade)
#  binding.pry

  newstudent
  # create a new Student object given a row from the database
end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      grade TEXT
    )
    SQL

      DB[:conn].execute(sql)

  end

  def self.drop_table
  sql = "DROP TABLE IF EXISTS students"
  DB[:conn].execute(sql)
  end

  def self.create (newname, newgrade)
    newstudent=self.new(newname, newgrade)
    newstudent.save
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET grade = "#{self.grade}", name = "#{self.name}"
      WHERE id = #{self.id}
    SQL

  #  binding.pry
      DB[:conn].execute(sql)
    end
end
