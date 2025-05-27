class Group < ApplicationRecord
    has_many :memberships
    has_many :users, through: :memberships
    has_many :expenses, -> { order(date: :desc) }, dependent: :destroy
end
