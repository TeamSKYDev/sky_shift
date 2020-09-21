class Store < ApplicationRecord

	has_many :staffs
	has_many :users, through: :staffs


    validates :name, presence: true


	def self.search(search)
		if search
			Store.find_by(['uuid LIKE ?', "#{search}"])
		end
	end


end
