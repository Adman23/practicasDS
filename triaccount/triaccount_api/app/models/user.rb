class User < ApplicationRecord
    has_secure_password
    has_many :memberships
    has_many :groups, through: :memberships
    has_many :expenses, foreign_key: :buyer_id

    validates :email, presence: true, uniqueness: true
end
