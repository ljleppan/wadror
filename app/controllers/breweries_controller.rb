class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :nglist]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :skip_if_cached, only: [:index]

  # GET /breweries
  # GET /breweries.json
  def index
    @breweries = Brewery.includes(:ratings, :beers).all
    @active_breweries = Brewery.includes(:ratings, :beers).active
    @retired_breweries = Brewery.includes(:ratings, :beers).retired

    case @order
      when 'name' then
        @breweries.sort_by!{ |b| b.name }
        @active_breweries.sort_by!{ |b| b.name }
        @retired_breweries.sort_by!{ |b| b.name }

      when 'year' then
        @active_breweries.sort_by!{ |b| b.year }
        @retired_breweries.sort_by!{ |b| b.year }
        @breweries.sort_by!{ |b| b.year }
    end
  end

  # GET /ngbrewerylist
  def nglist
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render action: 'show', status: :created, location: @brewery }
      else
        format.html { render action: 'new' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
    respond_to do |format|
      format.html { redirect_to breweries_url }
      format.json { head :no_content }
    end
  end

  # POST /breweries/1/toggle_activity
  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"
    ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }

    redirect_to :back, notice:"Brewery activity status changed to #{new_status}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def skip_if_cached
      @order = params[:order] || 'name'
      return render :index if fragment_exist? "brewerylist-#{@order}"
    end
end
