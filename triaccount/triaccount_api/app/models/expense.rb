class Expense < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :group

  has_one_attached :image
end
