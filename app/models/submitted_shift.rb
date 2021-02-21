class SubmittedShift < ApplicationRecord

	belongs_to :user
	belongs_to :store

	validate :end_time_is_after_start_time

	# def start_date
	# 	return Date.new
	# end

	private
    def end_time_is_after_start_time
        if end_time < start_time
          errors.add(:end_time, "cannot be before the start date")
        end
    end
end
