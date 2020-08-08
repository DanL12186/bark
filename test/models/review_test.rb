require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)

    @valid_review = Review.create(
      rating: 5,
      comment: "Great place",
      user_id: @user.id,
      restaurant_id: @restaurant.id
    )

    @blank_review = Review.create(rating: 5, user_id: @user.id, restaurant_id: @restaurant.id)

    @short_review = Review.create(
      rating: 5,
      comment: "Great",
      user_id: @user.id,
      restaurant_id: @restaurant.id
    )
  end

  test 'invalid when comment blank or too short' do
    assert_not @blank_review.valid?, 'user is valid without a password'
    assert @short_review.errors.messages[:comment].any? { | msg | msg.match?('too short') }
  end

  test 'valid review' do
    assert @valid_review.valid?
  end
end