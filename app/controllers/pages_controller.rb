class PagesController < ApplicationController
  include RestaurantsHelper

  #couldn't work out a way to order restaurants by average rating which both played well with pagination 
  #and displayed restaurants that didn't have reviews, and simply paginating after an AR Collection had been coerced into an array 
  #by calling #sort_by felt as though it nearly defeated the purpose of pagination performance-wise. 

  def home
    @restaurants = Restaurant.includes(:reviews).sort_by { | restaurant | -five_star_rating(restaurant.reviews) }
  end

end
