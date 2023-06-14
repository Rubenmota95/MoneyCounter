# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

puts "Deleting Database...."
User.delete_all
Goal.delete_all
Expense.delete_all
Income.delete_all
puts "Creating Database...."

# Create the test user
test_user = User.create!(
  email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'
)

GOAL_CATEGORIES = ["Education", "Travel", "Savings", "House"]
EXPENSE_CATEGORIES = ["Food", "Transportation", "Entertainment", "Housing", "Personal Care", "Utilities", "Debt and Loans"]
INCOME_CATEGORIES = ["Salary", "Freelance", "Investment"]
FREQUENCIES = ["One-time", "Monthly", "Weekly"]

# Delete expenses associated with the test user
test_user.expenses.delete_all

# Create goals for the user
5.times do |i|
  test_user.goals.create!(
    name: "Goal #{i + 1}",
    amount: rand(1000..10000),
    category: GOAL_CATEGORIES.sample
  )
end

# Create expenses for the user
5.times do |i|
  test_user.expenses.create!(
    amount: rand(10..100),
    category: EXPENSE_CATEGORIES.sample,
    name: "Expense #{i + 1}",
    frequency: FREQUENCIES.sample
  )
end

# Create incomes for the user
5.times do |i|
  test_user.incomes.create!(
    amount: rand(100..500),
    category: INCOME_CATEGORIES.sample,
    name: "Income #{i + 1}",
    frequency: FREQUENCIES.sample
  )
end

puts "Database Created! z0/"
