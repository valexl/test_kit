require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:person) { FactoryGirl.build(:person) }

  it 'save successfuly if build from FactoryGirl' do
    expect(person.save!).to eq(true)
  end
end
