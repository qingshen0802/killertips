# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.destroy_all
AdminUser.create!(email: 'admin@99killertips.com', password: 'admin123', password_confirmation: 'admin123')

10.times.each do |i|
  Pack.create!(name: "Pack#{i}", description: "Pack Description #{1}", price: i + 0.99)
end

['Media', 'Editing', 'Colour', 'Delivery', 'General'].each do |cat|
    Category.create!(name: cat)
end

Category.all.each do |cat|
  Pack.all.each do |p|
    8.times.each do |i|
      Tip.create!(title: "Tip#{i}", description: "Category: #{cat.name} - Tip#{i} - Pack: #{p.name}", category: cat, pack: p)
    end
  end
  8.times.each do |i|
    Tip.create!(title: "Tip#{i}", description: "Category: #{cat.name} - Tip#{i} - Pack: no", category: cat)
  end
end
