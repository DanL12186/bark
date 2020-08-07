require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    @restaurant = restaurants(:one)
    login_as User.create(id: @restaurant.user.id)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { name: @restaurant.name, user_id: @restaurant.user_id } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
  end

  test "should not get edit if not logged in" do
    logout

    get edit_restaurant_url(@restaurant)
    assert_response :redirect
  end

  test "should not get edit if not logged in with correct credentials" do
    logout
    login_as users(:two)

    get edit_restaurant_url(@restaurant)
    assert_response :redirect
  end

  test "should get edit if logged in with correct credentials" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant if logged in with correct credentials" do
    patch restaurant_url(@restaurant), params: { restaurant: { name: @restaurant.name, user_id: @restaurant.user_id } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should not destroy restaurant if not logged in" do
    logout

    assert_difference('Restaurant.count', 0) do
      delete restaurant_url(@restaurant)
    end

    assert_redirected_to new_user_session_path
  end

  test "should not destroy restaurant if logged in with invalid credentials" do
    logout
    login_as User.create(id: rand(10e6))

    assert_difference('Restaurant.count', 0) do
      delete restaurant_url(@restaurant)
    end

    assert_redirected_to root_path
  end

  test "should destroy restaurant if logged in with correct credentials" do
    assert_difference('Restaurant.count', -1) do
      delete restaurant_url(@restaurant)
    end

    assert_redirected_to restaurants_url
  end
end
