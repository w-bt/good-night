FactoryBot.define do
  factory :auth do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    association :user, factory: :user
  end
end
