module RestaurantsHelper

  def five_star_rating(reviews)
    return 'N/A' if reviews.size.zero?

    average_rating = reviews.map(&:rating).sum.to_f / reviews.size

    average_rating.round(2)
  end

end
