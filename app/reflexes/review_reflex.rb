# frozen_string_literal: true

class ReviewReflex < ApplicationReflex
  # Add Reflex methods in this file.
  #
  # All Reflex instances expose the following properties:
  #
  #   - connection - the ActionCable connection
  #   - channel - the ActionCable channel
  #   - request - an ActionDispatch::Request proxy for the socket connection
  #   - session - the ActionDispatch::Session store for the current visitor
  #   - url - the URL of the page that triggered the reflex
  #   - element - a Hash like object that represents the HTML element that triggered the reflex
  #   - params - parameters from the element's closest form (if any)
  #
  # Example:
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com
  def delete_review
    Review.find(element.dataset[:id]).destroy
    # flash[:notice] = 'Restaurant was successfully destroyed.'
  end

  def create_review
    restaurant = Restaurant.includes(:user).find(params[:id])
    user = User.find(element[:data_current_user])

    if restaurant.user == user
      return redirect_to root_path
    else
      review = restaurant.reviews.new(params[:review].permit(:rating, :comment))
      review.user = user
      review.photos.attach(params[:review][:photo])
      
      if review.save && Rails.env.production?
        review_details = { 
          user: restaurant.user, 
          reviewer: user, 
          restaurant: restaurant, 
          review: review, 
          photo_count: review.photos.size 
        }
        
        UserMailer.with(review_details).review_notification_email.deliver_later
      end
    end 
  end
end