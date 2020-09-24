class Room < ApplicationRecord
    has_many :room_users, dependent: :destroy
    has_many :users, through: :room_users
    
    has_many :messages, dependent: :destroy

    belongs_to :store

    def default_name(current_user)
        name = ""
        self.users.each do |user|
            if current_user != user
                name += (user.full_name + ", ")
            end
        end
        return name
    end
end
