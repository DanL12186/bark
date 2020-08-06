# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times {
  User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
}

unique_ids = User.pluck(:id)

#have each user own two restaurants
user_ids = unique_ids + unique_ids

(0...10).each do | idx |
  Restaurant.create(
   name: Faker::Restaurant.name,
   user_id:  user_ids[idx]
  )
end