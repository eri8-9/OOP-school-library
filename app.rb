require_relative 'book'
require_relative 'student'
require_relative 'teacher'
require_relative 'rental'
require_relative 'people'
require_relative 'manage_files'

class App
  include ManageFiles
  include People

  attr_reader :books, :people, :rentals

  def initialize(books = [], people = [], rentals = [])
    @books = books
    @people = people
    @rentals = rentals
  end

  def list_all_books
    puts
    puts @books.empty? ? 'Empty list!' : @books.map { |book| "Title: #{book.title}, Author: #{book.author}" }
  end

  def list_all_people
    puts
    return puts 'Empty list!' if @people.empty?

    # puts JSON.parse(File.read('data/people.json'))
    puts(@people.map { |people| "[#{people.class}] Name: #{people.name}, ID: #{people.id}, Age: #{people.age}" })
  end

  def create_person
    puts
    print 'Do you want to create a student (1) or teacher (2)? [Input the number]: '
    person = gets.chomp

    student_statement(person)

    teacher_statement(person)

    ManageFiles.add_obj_to_people_file(@people)
  end

  def create_book
    puts
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    puts
    book = Book.new(title, author)
    return unless book

    @books << book
    puts 'Book created successfully'
  end

  def create_rental
    puts
    return puts 'No Books or People available!' if @books.empty? || @people.empty?

    puts 'Select a book from the following list by number'
    puts(@books.map.with_index { |book, idx| "#{idx}) Title: #{book.title}, Author: #{book.author}" })
    book = gets.chomp
    puts 'Select a person from the following list (no id)'
    puts(@people.map.with_index do |people, idx|
           "#{idx}) [#{people.class}] Name: #{people.name}, ID: #{people.id}, Age: #{people.age}"
         end)
    person = gets.chomp
    print 'Date: '
    date = gets.chomp
    rental = Rental.new(date, @people[person.to_i], @books[book.to_i])
    return unless rental

    @rentals << rental
    puts
    puts 'Rental created successfully'
  end

  def list_all_rentals
    puts
    return puts "You don't have rentals" if @rentals.empty?

    print 'ID of person: '
    id = gets.chomp
    rentals = @rentals.filter { |rental| rental.person.id == id.to_i }
    puts 'Rentals: '
    puts(rentals.map { |rental| "Date: #{rental.date}, Book #{rental.book.title} by #{rental.book.author} " })
  end
end
