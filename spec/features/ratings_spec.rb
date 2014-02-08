require 'spec_helper'
include OwnTestHelper

describe 'Adding a rating' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:beer1) { FactoryGirl.create :beer, name:'Iso 3', brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
  end

  it 'registers the created rating to the beer and the logged in user' do
    visit new_rating_path
    select('Iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button 'Create Rating'
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end


describe 'Ratings page' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:beer1) { FactoryGirl.create :beer, name:'Iso 3', brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  it 'should be empty if no ratings exist' do
    visit ratings_path
    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Number of ratings: 0'
  end

  it 'should list all the ratings in the database' do
    FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:15, beer:beer2, user:user)

    visit ratings_path

    expect(page).to have_content 'Number of ratings: 2'
    expect(page).to have_content 'Iso 3'
    expect(page).to have_content 'Karhu'
  end
end
