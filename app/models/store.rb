class Store < ApplicationRecord
    has_many :rooms
    # has_one :main_room, class_name: "Room"
    validates :name, presence: true
end
