class PagesController < ApplicationController
  include RestaurantsHelper

  def home
    @restaurants = Restaurant.includes(:reviews)
                             .all
                             .sort_by { | restaurant | -five_star_rating(restaurant.reviews) }
  end

end
