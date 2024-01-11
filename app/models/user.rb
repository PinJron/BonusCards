class User < ApplicationRecord
  has_many :cards, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def total_bonuses
    cards.sum(:bonuses)
  end
end
