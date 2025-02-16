FactoryBot.define do
  factory :clock do
    association :user
    clock_in { Time.now }
    clock_out { Time.now + 8.hours }
    duration { clock_out.present? && clock_in.present? ? (clock_out - clock_in) : 0 }
  end
end
