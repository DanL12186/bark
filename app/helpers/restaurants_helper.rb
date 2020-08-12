module RestaurantsHelper
  include Pagy::Frontend

  def five_star_rating(reviews)
    return 0 if reviews.size.zero?

    average_rating = reviews.map(&:rating).sum.fdiv(reviews.size)

    average_rating.round(2)
  end

end
