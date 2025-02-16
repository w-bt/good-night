FactoryBot.define do
  factory :clock_weekly do
    association :user
    week_start { Date.today.beginning_of_week }
    total_duration { 0 }
  end
end
