class Member < ApplicationRecord
    has_many :receipts, dependent: :destroy 
    validates :name, presence: true, length: { minimum: 2}
end
