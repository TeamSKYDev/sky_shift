class StaffLabel < ApplicationRecord
	belongs_to :label
	belongs_to :staff
end
