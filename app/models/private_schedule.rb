class PrivateSchedule < ApplicationRecord
    belongs_to :user


    def start_date
        return start_time.to_date
    end
end
