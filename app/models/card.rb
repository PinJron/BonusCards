class Card < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  # validates :type, presence: true
  validates :bonuses, presence: true
end
