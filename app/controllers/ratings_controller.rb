class RatingsController < ApplicationController

  def index
    #Cachetaan koko roska 10min expirellä, haetaan tiedot kannasta vain jos cachessa oleva on expiroitunut
    unless Rails.cache.exist? 'ratingslist'
      @most_recent_ratings = Rating.recent.includes(:user, :beer, :beer => :brewery, :beer => :style)
      @users_with_most_ratings = User.most_ratings(3).includes(:ratings)
      @best_breweries = Brewery.top(3).includes(:beers, :ratings)
      @best_beers = Beer.top(3).includes(:style, :ratings)
      @best_styles = Style.top(3)
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end