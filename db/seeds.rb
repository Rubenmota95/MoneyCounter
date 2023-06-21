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
CATEGORIES = ['Food',
  'Health',
  'Entertainment',
  'Travel',
  'Personal Care',
  'Education',
  'Utilities',
  'Salary',
  'Investments',
  'Rental Income',
  'Freelance',
  'Other...']
TYPE = ['Expense', 'Income']
FREQUENCIES = ["One-time", "Monthly", "Weekly"]



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
40.times do |i|
  created_at = Faker::Time.between(from: 1.month.ago, to: Time.zone.now)
  test_user.transactions.create!(
    amount: rand(10..150),
    category: CATEGORIES.sample,
    name: "Transaction #{i + 1}",
    kind: TYPE.sample,
    frequency: FREQUENCIES.sample,
    created_at: created_at,
  )
end

puts "Database Created! z0/"
