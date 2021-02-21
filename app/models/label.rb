class Label < ApplicationRecord

	belongs_to :store
	has_many :staff_labels
	has_many :staffs, through: :staff_labels

	enum work_type: {position: 1, ability: 2, rank: 3, other: 4}

	validates :name, presence: true

	attr_writer :select_staff_ids

	def select_staff_ids
		@select_staff_ids
	end


	def self.search(label_name, store_id)
		if label_name.present?
			Label.where(store_id: store_id).where(['name LIKE ?', "%#{label_name}%"])
		else
			Label.where(store_id: store_id).all
		end
	end
end
