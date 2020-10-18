class Task < ApplicationRecord

	belongs_to :store

	has_many :user_tasks, dependent: :destroy

	validates :title, presence: true

end
