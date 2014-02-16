require 'spec_helper'

describe Beer do
  it 'is saved if it has name and style' do
    beer = Beer.create name:'TestiOlut', style_id:1

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it 'is not saved if it has no name' do
    beer = Beer.create style_id:1

    expect(beer).to_not be_valid
    expect(Beer.count).to eq(0)
  end

  it 'is not saved if it has no style' do
    beer = Beer.create name:'Testiolut'

    expect(beer).to_not be_valid
    expect(Beer.count).to eq(0)
  end
end
