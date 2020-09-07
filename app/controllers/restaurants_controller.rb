class RestaurantsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :prevent_unauthorized_action, only: [:edit, :update, :destroy]

  def index
    @pagy, @restaurants = pagy(
      Restaurant.includes(:reviews, :user).order(:name)
    )
  end

  def show
    @reviews = @restaurant.reviews
                          .includes(:user, photos_attachments: :blob)
                          .with_rich_text_comment_and_embeds
                          .order(created_at: :desc)
                          
    @new_review = Review.new if current_user
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    @restaurant.photos.attach(params[:restaurant][:photo])

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @restaurant.photos.attach(params[:restaurant][:photo])

    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_restaurant
      @restaurant = Restaurant.includes(:reviews, :user).find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name)
    end

    def prevent_unauthorized_action
      redirect_to root_path unless current_user == @restaurant.user
    end
end