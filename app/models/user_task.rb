class UserTask < ApplicationRecord

	belongs_to :task
	belongs_to :user

	attr_writer :assign_task_ids

	def assign_task_ids
		@assign_task_ids
	end
end
