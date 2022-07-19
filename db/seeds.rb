# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

company_arr = []
10.times do |k|
  company_arr << {code: "Company-0#{k}", name: Faker::Company.name}
end

Company.create(company_arr)

Company.all.each do |c|
  c.groups.create(name: Faker::TvShows::StarTrek.character)
  c.users.create(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, age: 30, user_group_attributes: {group_id: c.groups.first.id})
end

