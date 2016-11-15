# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do |i|
  User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password")
  Course.create!(title: Faker::App.name, summary: Faker::Lorem.paragraph, level: "Beginner", appx_length: "#{i} weeks")
end