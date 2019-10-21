class Receipt < ApplicationRecord
  belongs_to :member
  validates :number, presence: true, numericality: {only_integer: true}, uniqueness: true
  validates :donation_year, presence: true, numericality: {only_integer: true}
  
end
