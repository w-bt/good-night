FactoryBot.define do
  factory :clock_daily do
    association :user
    date { Date.today }
    total_duration { 0 }
  end
end
