# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
require 'faker'

puts "Deleting Database...."
Goal.delete_all
Transaction.delete_all
User.delete_all
puts "Creating Database...."

test_user = User.create!(
  email: 'test@example.com',
  username: 'test123',
  password: 'password',
  password_confirmation: 'password'
)

GOAL_CATEGORIES = ['Product', 'Financial']
CATEGORIES_expense = ['Groceries',
'Health',
'Fun',
'Travel',
'Education',
'Utilities',
'Other']

CATEGORIES_income = ['Salary',
'Freelance',
'Resell',
'Birthday',
'Christmas',
'Lottery',
'Other']

test_user.transactions.delete_all

i = 0
5.times do |i|
  test_user.goals.create!(
    name: "Goal #{i + 1}",
    amount: rand(1000..10000),
    category: GOAL_CATEGORIES.sample
  )
end

i = 0
20.times do |i|
  created_at = Faker::Time.between(from: 1.month.ago, to: Time.zone.now)
  test_user.transactions.create!(
    amount: rand(10..300),
    category: CATEGORIES_expense.sample,
    name: "Transaction #{i + 1}",
    kind: "Expense",
    created_at: created_at,
  )
end

i = 0
10.times do |i|
  created_at = Faker::Time.between(from: 1.month.ago, to: Time.zone.now)
  test_user.transactions.create!(
    amount: rand(100..1200),
    category: CATEGORIES_income.sample,
    name: "Transaction #{i + 1}",
    kind: "Income",
    created_at: created_at,
  )
end


puts "Database Created! z0/"
