require 'spec_helper'
include OwnTestHelper

describe 'User page' do
  let!(:brewery1) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:brewery2) { FactoryGirl.create :brewery, name:'Olvi' }
  let!(:beer1) { FactoryGirl.create :beer, name:'Iso 3', brewery:brewery1 }
  let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery1 }
  let!(:beer3) { FactoryGirl.create :beer, name:'Olvi', brewery:brewery2 }
  let!(:style2){ FactoryGirl.create :style, name:'Weizen' }
  let!(:beer4) { FactoryGirl.create :beer, name:'Weizze', style:style2, brewery:brewery1 }
  let!(:user1) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:'Matti', password:'P4ssu', password_confirmation:'P4ssu' }

  describe 'ratings list' do

    before :each do
      FactoryGirl.create(:rating, score:10, beer:beer1, user:user1)
      FactoryGirl.create(:rating, score:12, beer:beer2, user:user1)
      FactoryGirl.create(:rating, score:22, beer:beer1, user:user2)
      FactoryGirl.create(:rating, score:23, beer:beer2, user:user2)
    end

    it 'should display user\'s own ratings' do
      visit user_path(user1)

      expect(page).to have_content 'Ratings'
      expect(page).to have_content 'Has made 2 ratings'
      expect(page).to have_content 'Iso 3 Lager Koff 10'
      expect(page).to have_content 'Karhu Lager Koff 12'
    end

    it 'should not display other users\' ratings' do
      visit user_path(user1)

      expect(page).to_not have_content 'Iso 3 Lager Koff 22'
      expect(page).to_not have_content 'Karhu Lager Koff 23'
    end

    it 'delete button should delete said rating' do
      sign_in(username: 'Pekka', password: 'Foobar1')
      visit user_path(user1)

      expect{
        page.find('tr', text:'Iso 3').click_link('delete')
      }.to change{Rating.count}.by(-1)
    end
  end

  describe 'favourite style' do
    it 'text should be present even if no ratings' do
      visit user_path(user1)
      expect(page).to have_content 'Favourite style: unknown'
    end

    it 'should display favourite style if any ratings' do
      FactoryGirl.create(:rating, score:10, beer:beer1, user:user1)
      FactoryGirl.create(:rating, score:11, beer:beer2, user:user1)
      FactoryGirl.create(:rating, score:12, beer:beer3, user:user1)
      FactoryGirl.create(:rating, score:13, beer:beer4, user:user1)

      visit user_path(user1)
      expect(page).to have_content 'Favourite style: Weizen'
    end
  end

  describe 'favourite beer' do
    it 'text should be present even if no ratings' do
      visit user_path(user1)
      expect(page).to have_content 'Favourite beer: unknown'
    end

    it 'should display favourite beer if any ratings' do
      FactoryGirl.create(:rating, score:10, beer:beer1, user:user1)
      FactoryGirl.create(:rating, score:11, beer:beer2, user:user1)
      FactoryGirl.create(:rating, score:12, beer:beer3, user:user1)
      FactoryGirl.create(:rating, score:13, beer:beer4, user:user1)

      visit user_path(user1)
      expect(page).to have_content 'Favourite beer: Weizze'
    end
  end

  describe 'favourite brewery' do
    it 'text should be present even if no ratings' do
      visit user_path(user1)
      expect(page).to have_content 'Favourite beer: unknown'
    end

    it 'should display favourite brewery if any ratings' do
      FactoryGirl.create(:rating, score:10, beer:beer1, user:user1)
      FactoryGirl.create(:rating, score:11, beer:beer2, user:user1)
      FactoryGirl.create(:rating, score:12, beer:beer3, user:user1)
      FactoryGirl.create(:rating, score:13, beer:beer4, user:user1)

      visit user_path(user1)
      expect(page).to have_content 'Favourite brewery: Olvi' # Olvi 12, Karhu 11.3
    end
  end

end