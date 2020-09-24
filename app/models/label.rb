class Label < ApplicationRecord

	belongs_to :store
	has_many :staff_labels
	has_many :staffs, through: :staff_labels

	enum work_type: {position: 1, ability: 2, rank: 3, other: 4}

	validates :name, presence: true

end
