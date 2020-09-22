class Store < ApplicationRecord
    has_many :rooms
    # has_one :main_room, class_name: "Room"

	has_many :staffs
	has_many :users, through: :staffs


    validates :name, presence: true


	def self.search(search)
		if search
			Store.find_by(['uuid LIKE ?', "#{search}"])
		end
	end


end
