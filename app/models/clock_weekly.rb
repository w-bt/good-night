class ClockWeekly < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :week_start, presence: true
  validates :total_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
