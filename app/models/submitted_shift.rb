class SubmittedShift < ApplicationRecord

	belongs_to :user
	belongs_to :store

	# def start_date
	# 	return Date.new
	# end
end
