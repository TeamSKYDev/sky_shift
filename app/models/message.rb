class Message < ApplicationRecord
    belongs_to :room
    belongs_to :user, foreign_key: "creator_id"
    validates :content, presence: true

    after_create_commit { MessageBroadcastJob.perform_later self }
end
