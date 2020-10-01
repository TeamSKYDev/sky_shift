class PrivateSchedule < ApplicationRecord
    belongs_to :user

    validates :title, presence: true
    validate :end_time_is_after_start_time

    def start_date
        return start_time.to_date
    end

    private
    def end_time_is_after_start_time
  
    if end_time < start_time
      errors.add(:end_time, "cannot be before the start date") 
    end 
  end
end
