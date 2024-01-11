# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

20.times do
  Shop.create(name: FFaker::CheesyLingo.title)
end

20.times do
  User.create(email: FFaker::Internet.email, negative_balance: false)
end

20.times do
  Card.create(bonuses: rand(1..1000), user_id: rand(1..10), shop_id: rand(1..10))
end

Card.create(bonuses: rand(1..1000), user_id: 2, shop_id: 2)
Card.create(bonuses: rand(1..1000), user_id: 2, shop_id: 2)
