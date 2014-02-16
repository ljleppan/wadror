require 'spec_helper'
include OwnTestHelper

describe 'Adding a beer' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:style) {FactoryGirl.create :style}
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit new_beer_path
  end

  it 'fails if blank name' do
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(current_path).to eq(beers_path)
    expect(page).to have_content 'Name can\'t be blank'
  end

  it 'succeeds if name is not blank' do
    fill_in('beer[name]', with:'Iso 3')


    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)

    expect(current_path).to eq(beers_path)
  end
end