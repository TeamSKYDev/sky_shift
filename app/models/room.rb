class Room < ApplicationRecord
    has_many :room_users, dependent: :destroy
    has_many :users, through: :room_users
    
    has_many :messages

    belongs_to :store

    def default_name
        name = ""
        self.users.each do |user|
            name += (user.full_name + ", ")
        end
        return name
    end
end
