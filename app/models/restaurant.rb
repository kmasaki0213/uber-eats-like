class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods

  validates :name, presence: true, length: { maximum: 30 }
  validates :fee, presence: true, numericality: { greater_than: 0 }
  validates :time_required, presence: true
end
