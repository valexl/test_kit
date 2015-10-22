require 'rails_helper'

RSpec.describe IKit::TestIkit::Parser::Page do
  let(:nokogiri_page) do
    path_to_page = "#{Dir.pwd}/spec/fixtures/files/resource_page1.html"
    Nokogiri::HTML(open(path_to_page)) 
  end
  let(:page) { IKit::TestIkit::Parser::Page.new nokogiri_page }
  let(:expected_attributes) do
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

  it 'has get_attributes method which will return expected_attributes' do
    expect(page.get_attributes).to eq(expected_attributes)
  end
end
