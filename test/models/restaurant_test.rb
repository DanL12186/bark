require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  setup do
    @valid_restaurant = restaurants(:one)
    @restaurant_without_name = Restaurant.new(user_id: 4)
    @restaurant_without_user_id = Restaurant.new(name: "Spartacus")
  end

  test 'invalid without name' do
    assert_not @restaurant_without_name.valid?
  end

  test 'invalid without user_id' do
    assert_not @restaurant_without_user_id.valid?
  end

  test 'valid restaurant' do
    assert @valid_restaurant.valid?
  end
end
