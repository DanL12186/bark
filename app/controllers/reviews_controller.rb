class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def create
    @restaurant = Restaurant.includes(:user).find(params[:restaurant_id])

    if @restaurant.user == current_user
      return redirect_to root_path
    else
      @review = @restaurant.reviews.new(params[:review].permit(:rating, :comment))
      @review.user = current_user
      @review.photos.attach(params[:review][:photo])
      
      if @review.save
        review_details = { 
          user: @restaurant.user, 
          reviewer: current_user, 
          restaurant: @restaurant, 
          review: @review, 
          photo_count: @review.photos.size 
        }
        
        #I didn't explicitly integrate this into ActiveJob because it does this automatically and is async with .deliver_later
        UserMailer.with(review_details).review_notification_email.deliver_later unless 1 == 1
      end
    end

    redirect_to restaurant_path(@restaurant)    
  end

  def destroy
    @restaurant = Restaurant.includes(:reviews).find(params[:restaurant_id])
    @review = @restaurant.reviews.find(params[:id])

    unless @review.user == current_user
      redirect_to root_path
    else
      @review.destroy
      redirect_to restaurant_path(@restaurant)
    end
  end
end