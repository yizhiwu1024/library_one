puts "Seeding users..."

admin = User.find_or_initialize_by(email: "admin@library.com")
admin.assign_attributes(password: "123456", password_confirmation: "123456", role: :admin, status: :active)
admin.save!
admin.user_profile&.update!(full_name: "System Admin", phone: "10000000000", address: "Library HQ")

member = User.find_or_initialize_by(email: "user@library.com")
member.assign_attributes(password: "123456", password_confirmation: "123456", role: :member, status: :active)
member.save!
member.user_profile&.update!(full_name: "Test Member", phone: "18888888888", address: "Campus Road")

puts "Seeding categories..."

categories = {
  "Computer Science" => nil,
  "Mathematics" => nil,
  "Literature" => nil
}

categories.keys.each do |name|
  categories[name] = Category.find_or_create_by!(name: name)
end

puts "Seeding books..."

book_data = [
  { title: "Programming Ruby", author: "Dave Thomas", isbn: "9780974514055", category: "Computer Science", description: "A practical guide to Ruby language fundamentals and Rails-related development patterns.", total: 6, available: 4 },
  { title: "Clean Code", author: "Robert C. Martin", isbn: "9780132350884", category: "Computer Science", description: "Classic software engineering practices focused on readability, maintainability, and design discipline.", total: 5, available: 5 },
  { title: "Linear Algebra Done Right", author: "Sheldon Axler", isbn: "9783319110790", category: "Mathematics", description: "A proof-oriented introduction to vector spaces, linear maps, and eigenvalue theory.", total: 3, available: 1 },
  { title: "Discrete Mathematics", author: "Kenneth Rosen", isbn: "9780073383095", category: "Mathematics", description: "Covers logic, sets, combinatorics, graph theory, and discrete structures for computing.", total: 2, available: 0 },
  { title: "Pride and Prejudice", author: "Jane Austen", isbn: "9780141439518", category: "Literature", description: "A classic novel exploring social expectations, family, and personal growth.", total: 4, available: 0 }
]

books = {}
book_data.each do |row|
  book = Book.find_or_initialize_by(isbn: row[:isbn])
  book.assign_attributes(
	title: row[:title],
	author: row[:author],
	category: categories[row[:category]],
    description: row[:description],
	total_copies: row[:total],
	available_copies: row[:available]
  )
  book.save!
  books[row[:title]] = book
end

puts "Seeding borrowings..."

active_borrowing = Borrowing.find_or_initialize_by(user: member, book: books["Programming Ruby"], status: "borrowed")
active_borrowing.assign_attributes(borrowed_on: Date.current - 2.days, due_on: Date.current + 8.days, returned_on: nil, renewal_count: 0)
active_borrowing.save!

overdue_borrowing = Borrowing.find_or_initialize_by(user: member, book: books["Linear Algebra Done Right"], status: "overdue")
overdue_borrowing.assign_attributes(borrowed_on: Date.current - 20.days, due_on: Date.current - 10.days, returned_on: nil, renewal_count: 1)
overdue_borrowing.save!

puts "Seed complete."
puts "Admin account: admin@library.com / 123456"
puts "Member account: user@library.com / 123456"
