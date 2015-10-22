require 'rails_helper'

RSpec.describe IKit::TestIkit::Parser::Runner do
  let(:runner) { @runner ||= IKit::TestIkit::Parser::Runner.new 'some string' }
  let(:returned_attributes) do
    [
      {
        name:       'Ruslan Abdalov',
        city:       'Krasnoznamensk, Moscow',
        country:    'Russian Federation',
        credential: 'PMP',
        earned:     '09 Jul 2015'.to_date,
        status:     'Active',
      },
      {
        name: 'Ruslan Abdrakhmanov',
        city: 'St. Petersburg',
        country: 'Russian Federation',
        credential: 'PMP',
        earned: '01 Jul 2010'.to_date,
        status: 'Active',
      },
    ]
  end

  before(:all) do
    Person.delete_all
  end

  before(:each) do
    allow(IKit::TestIkit::Parser::Page).to receive(:new) do 
      mock = double
      allow(mock).to receive(:get_attributes).and_return(returned_attributes)
      mock
    end
    allow(runner).to receive(:get_html).and_return('')
    expect(IKit::TestIkit::Parser::Page.new("something").get_attributes).to eq(returned_attributes)
  end


  it 'has save_resources! method which will create 2 Person' do
    expect do
      runner.save_resources!
    end.to change(Person, :count).by (2)
  end
end
