require 'spec_helper'

describe User do
  it 'has the username set correctly' do
    user = User.new username:'Pekka'

    user.username.should == 'Pekka'
  end

  it 'is not saved without a password' do
    user = User.create username:'Pekka'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'is not saved with a password consisting of only letters' do
    user = User.create username:'Pekka', password:'Secret', password_confirmation:'Secret'
    expect(user).to_not be_valid
    expect(User.count).to eq(0)
  end

  it 'is not saved with a too short password' do
    user = User.create username:'Pekka', password:'S', password_confirmation:'S'
    expect(user).to_not be_valid
    expect(User.count).to eq(0)
  end

  describe 'with a proper password' do
    let(:user){FactoryGirl.create(:user)}

    it 'is saved' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has the correct average ratings' do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe 'favourite beer' do
    let(:user){FactoryGirl.create(:user)}

    it 'has method for determining one' do
      user.should respond_to :favourite_beer
    end

    it 'without ratings does not have one' do
      expect(user.favourite_beer).to eq(nil)
    end

    it 'is the only rated beer if only one rating' do
      beer = create_beer_with_rating(10, user)

      expect(user.favourite_beer).to eq(beer)
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_ratings(10, 20, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favourite_beer).to eq(best)
    end
  end

  describe 'favourite style' do
    let(:user){FactoryGirl.create(:user)}

    it 'has method for determining one' do
      user.should respond_to :favourite_style
    end

    it 'without ratings does not have one' do
      expect(user.favourite_style).to eq(nil)
    end

    it 'is the only rated beer\'s style if only one rating' do
      beer = create_beer_with_rating_and_style(35, 'Weizen', user)
      expect(user.favourite_style).to eq('Weizen')
    end

    it 'is the style with highest average rating if several rated' do
      create_beers_with_ratings_and_styles(10, 15, 7, 'Lager', user)
      create_beers_with_ratings_and_styles(40, 30, 'Weizen', user)
      create_beers_with_ratings_and_styles(20, 30, 'IPA', user)

      expect(user.favourite_style).to eq('Weizen')
    end
  end

  describe 'favourite brewery' do
    let(:user){FactoryGirl.create(:user)}

    it 'has method for determining one' do
      user.should respond_to :favourite_brewery
    end

    it 'without ratings does not have one' do
      expect(user.favourite_brewery).to eq(nil)
    end

    it 'is the only rated beer\'s brewery if only one rating' do
      brewery = FactoryGirl.create(:brewery, name:'brewery')
      beer = create_beer_with_rating_and_brewery(35, brewery, user)
      expect(user.favourite_brewery).to eq(brewery)
    end

    it 'is the brewery with highest average rating if several rated' do
      brewery1 = FactoryGirl.create(:brewery, name:'brewery1')
      brewery2 = FactoryGirl.create(:brewery, name:'brewery2')
      brewery3 = FactoryGirl.create(:brewery, name:'brewery3')
      create_beers_with_ratings_and_breweries(10, 15, 7, brewery1, user)
      create_beers_with_ratings_and_breweries(40, 30, brewery2, user)
      create_beers_with_ratings_and_breweries(20, 30, brewery3, user)

      expect(user.favourite_brewery).to eq(brewery2)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beer_with_rating_and_style(score, style, user)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings_and_styles(*scores, style, user)
    scores.each do |score|
      create_beer_with_rating_and_style(score, style, user)
    end
  end

  def create_beer_with_rating_and_brewery(score, brewery, user)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings_and_breweries(*scores, brewery, user)
    scores.each do |score|
      create_beer_with_rating_and_brewery(score, brewery, user)
    end
  end
end
