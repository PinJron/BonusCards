class Card < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  # validates :type, presence: true
  validates :bonuses, presence: true

  def decrement_bonuses!(amount) = update!('bonuses = bonuses - ?', amount)
  def increment_bonuses!(amount) = update!('bonuses = bonuses + ?', amount)
end
