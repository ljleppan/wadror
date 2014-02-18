class RatingsController < ApplicationController

  def index
    @most_recent_ratings = Rating.recent_5
    @users_with_most_ratings = User.most_ratings 3
    @best_breweries = Brewery.top 3
    @best_beers = Beer.top 3
    @best_styles = Style.top 3
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