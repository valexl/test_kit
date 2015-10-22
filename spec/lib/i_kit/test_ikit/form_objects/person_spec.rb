require 'rails_helper'

RSpec.describe IKit::TestIkit::FormObjects::Person do
  let(:attributes) do
      {
        name:       'Ruslan Abdalov',
        city:       'Krasnoznamensk, Moscow',
        country:    'Russian Federation',
        credential: 'PMP',
        earned:     '09 Jul 2015'.to_date,
        status:     'Active',
      }
  end

  let(:person_object) { IKit::TestIkit::FormObjects::Person.new(attributes) }

  context 'save method which' do
    it 'creates new if Person does not contain record with same name' do
      expect do
        person_object.save!
      end.to change(Person, :count).by(1)
    end

    it 'does not create new record if Person with same name is existed' do
      FactoryGirl.create(:person, name: attributes[:name])
      expect do
        person_object.save!
      end.to change(Person, :count).by(0)
    end
  end

  
end

