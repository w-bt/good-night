require 'faker'
require 'factory_bot'

# Create 100 users
FactoryBot.create_list(:auth, 100)

puts "100 users created"

# For each user, follow 10-100 random users
users = User.all
users.each do |user|
  followees = users.sample(rand(10..100))
  followees.each do |followee|
    next if user == followee
    Follow.create!(follower: user, followee: followee) rescue nil
  end
end

puts "users relationship created"

# For each user, create clock records for the last 7 days
users.each do |user|
  (1..7).each do |i|
    clock_in = Faker::Time.between_dates(from: Date.today - i, to: Date.today - i, period: :evening)
    clock_out = Faker::Time.between_dates(from: Date.today - i + 1, to: Date.today - i + 1, period: :morning)
    Clock.create!(user: user, clock_in: clock_in, clock_out: clock_out)
  end
end

puts "clock records for the last 7 days created"
