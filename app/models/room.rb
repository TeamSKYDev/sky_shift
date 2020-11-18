class Room < ApplicationRecord
    has_many :room_users, dependent: :destroy
    has_many :users, through: :room_users
    
    has_many :messages, dependent: :destroy

    belongs_to :store

    def default_name(current_user)
        name = []
        self.users.each do |user|
            if current_user != user
                name.append(user.full_name)
            end
        end
        return name.join(', ')
    end

    def last_message
        return self.messages.order(created_at: :desc).take
    end

    def last_datetime
        if last_message
            return Time.at(last_message.created_at.to_i).to_datetime
        else
            return Time.at(updated_at.to_i).to_datetime
        end
    end

    def last_date
        last_datetime.to_date
    end
    
end
