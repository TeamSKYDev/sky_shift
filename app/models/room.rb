class Room < ApplicationRecord
    has_many :users, through: :room_users
    has_many :room_users, dependent: :destroy

    has_many :messages

    belongs_to :store
end
