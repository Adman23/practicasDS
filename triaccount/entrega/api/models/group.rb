class Group < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    has_many :expenses, -> { order(date: :desc) }, dependent: :destroy
end
