class Auth < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :user

  validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
end
