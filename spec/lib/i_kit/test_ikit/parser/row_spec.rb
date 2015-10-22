require 'rails_helper'

RSpec.describe IKit::TestIkit::Parser::Row do
  let(:page) do
    path_to_page = "#{Dir.pwd}/spec/fixtures/files/resource_page1.html"
    Nokogiri::HTML(open(path_to_page)) 
  end
  let(:nokogiri_row) { page.search("tr#dph_RegistryContent_SearchResults_ctl01_registryListItem") }
  let(:row) { IKit::TestIkit::Parser::Row.new nokogiri_row }
  let(:expected_attributes) do
    {
      name:       'Ruslan Abdalov',
      city:       'Krasnoznamensk, Moscow',
      country:    'Russian Federation',
      credential: 'PMP',
      earned:     '09 Jul 2015'.to_date,
      status:     'Active',
    }
  end

  it 'has get_attributes method which will return expected_attributes' do
    expect(row.get_attributes).to eq(expected_attributes)
  end
end
