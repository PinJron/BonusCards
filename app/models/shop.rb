class Shop < ApplicationRecord
  has_many :cards, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
