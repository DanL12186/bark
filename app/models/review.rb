class Review < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  has_many_attached :photos
  has_rich_text :comment

  validates :comment, length: { minimum: 8 }
end

