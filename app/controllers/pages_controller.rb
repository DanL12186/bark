class PagesController < ApplicationController
  include RestaurantsHelper
  include Pagy::Backend

  def home
    @pagy, @restaurants = pagy(
      Restaurant.includes(:reviews)
                .left_outer_joins(:reviews)
                .group(:restaurant_id, :name)
                .order('AVG(reviews.rating) DESC')
    )
  end

end