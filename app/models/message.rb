class Message < ApplicationRecord
    belongs_to :room
    belongs_to :user, foreign_key: "creator_id"
    validates :content, presence: true

    after_create_commit { MessageBroadcastJob.perform_later self }

    def created_date
        Time.zone.at(created_at.to_i).to_datetime.to_date
    end

    def created_time
        Time.zone.at(created_at.to_i).to_datetime.strftime("%R")
    end
    
    def created_at_is_today
        created_date == Date.today
    end
end
