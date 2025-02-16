class Clock < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validate :validate_clock_in_out_constraints

  before_save :calculate_duration, if: :clock_out_changed?

  private

  def validate_clock_in_out_constraints
    if Clock.where(user_id: user_id, clock_in: nil, clock_out: nil).where.not(id: id).exists?
      errors.add(:base, "Each user can not have more than one record with null clock_in and null clock_out")
    end

    if Clock.where(user_id: user_id, clock_in: nil).where.not(id: id).exists?
      errors.add(:clock_in, "Each user can not have more than one record with null clock_in")
    end

    if Clock.where(user_id: user_id, clock_out: nil).where.not(id: id).exists?
      errors.add(:clock_out, "Each user can not have more than one record with null clock_out")
    end
  end

  def calculate_duration
    return unless clock_in.present? && clock_out.present?
    self.duration = (clock_out - clock_in).to_i
  end
end
