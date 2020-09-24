class Staff < ApplicationRecord

	belongs_to :user
	belongs_to :store

	attr_writer :select_label_ids

	has_many :staff_labels
	has_many :labels, through: :staff_labels

	def select_label_ids
		@select_label_ids
	end
end
