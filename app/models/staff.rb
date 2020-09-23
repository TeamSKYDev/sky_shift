class Staff < ApplicationRecord

	belongs_to :user
	belongs_to :store

	has_many :staff_labels
	has_many :labels, through: :staff_labels
end
