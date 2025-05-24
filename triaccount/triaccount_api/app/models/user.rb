class User < ApplicationRecord
    has_secure_password
    has_many :memberships
    has_many :groups, through: :membership
    has_many :expenses, foreign_key: :buyer_id
end
