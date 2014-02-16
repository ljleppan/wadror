class PlacesController < ApplicationController

  def index

  end

  def show
    @place = BeermappingApi.place(params[:id])
    if @place.nil?
      redirect_to places_path, notice: "Unknown location with id #{params[:id]}, please use the search feature below."
    else
      render :show
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.nil?
      redirect_to places_path
    elsif @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end