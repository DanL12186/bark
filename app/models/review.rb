class Review < ApplicationRecord
  include CableReady::Broadcaster

  belongs_to :user
  belongs_to :restaurant

  has_many_attached :photos
  has_rich_text :comment

  validates :comment, length: { minimum: 8 }

  after_update do
    cable_ready["reviews"].morph(
      #document.querySelector(`#${ActionView::RecordIdentifier.dom_id(self)})
      selector: "#" + ActionView::RecordIdentifier.dom_id(self),
      html: ApplicationController.render(self) # self = review
    )

    cable_ready.broadcast
    
  end
end