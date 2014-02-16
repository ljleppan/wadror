require 'spec_helper'

describe 'Places' do
  it 'if one is returned by the API, it is shown at the page' do
    BeermappingApi.stub(:places_in).with('kumpula').and_return(
        [ Place.new(name:'Oljenkorsi') ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'Oljenkorsi'
  end

  it 'if multiple returned by the API, all are shown on the page' do
    BeermappingApi.stub(:places_in).with('kumpula').and_return(
        [ Place.new(name:'Oljenkorsi'), Place.new(name:'Testipubi'), Place.new(name:'Navetta')]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'Oljenkorsi'
    expect(page).to have_content 'Testipubi'
    expect(page).to have_content 'Navetta'
  end

  it 'if none returned by the API, error is shown' do
    BeermappingApi.stub(:places_in).with('kumpula').and_return(
        [  ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'No locations in kumpula'
  end
end