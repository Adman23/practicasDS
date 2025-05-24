class Group < ApplicationRecord
    has_many :memberships
    has_many :users, through: :membership
    has_many :expenses
end
