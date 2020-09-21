class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum sex: {men: 1, women: 2, other: 3}

  has_many :rooms, through: :room_users
  has_many :room_users, dependent: :destroy

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :telephone_number, presence: true

  def active_for_authentication?
    super && (self.is_unsubscribe == false)
  end
end
