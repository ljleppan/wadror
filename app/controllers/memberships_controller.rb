class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:confirm]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user_id = current_user.id
    @membership.confirmed = false

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership.beer_club, notice: "Welcome to the club, #{current_user.username}" }
        format.json { render action: 'show', status: :created, location: @membership }
      else
        @membership.destroy
        @beer_clubs = BeerClub.all
        format.html { render action: 'new' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.json { head :no_content }
    end
  end

  # POST /memberships/1/toggle_activity
  def confirm
    membership = Membership.find(params[:id])
    if membership.beer_club.memberships.find_by(user_id:current_user.id).nil? or not membership.beer_club.memberships.find_by(user_id:current_user.id).confirmed
      redirect_to :back, notice:'You are not a member of this Beer Club'
    else
      membership.confirmed = true
      membership.save
      redirect_to :back, notice:"Confirmed membership of #{membership.user.username}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_id, :beer_club_id, current_user.id)
    end
end
