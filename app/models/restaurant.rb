class Restaurant < ApplicationRecord
  belongs_to :user

  has_many :reviews
  has_many_attached :photos

  validates :name, :user_id, presence: true
end
