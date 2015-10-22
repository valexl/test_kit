require 'rails_helper'

RSpec.describe IKit::TestIkit::Searcher::People do

  before(:all) do
    Person.delete_all
    Person.__elasticsearch__.delete_index! rescue nil
    Person.__elasticsearch__.create_index!

    @person  = FactoryGirl.create(:person, name: 'Miracle')

    @person_with_the_biggest_name         = FactoryGirl.create(:person, name: 'Arturov Ruslan')
    @person_with_the_smallest_name        = FactoryGirl.create(:person, name: 'Zaripov Artur')

    refresh_elasticsearch_cluster
  end

  describe "has class's method get_query" do
    it "will not change query and pass to multi_match if that contain just one word" do
      query = IKit::TestIkit::Searcher::People.get_query('Miracle')
      expect(query).to eq({
        filtered: {
          query: {
            multi_match: {
              query: "Miracle",
              fields: ["_all"],
              operator: 'AND'
            }
          },
        }
      })
    end

    it "will change query and will pass to multi_match if that contain several words without any names" do
      query = IKit::TestIkit::Searcher::People.get_query("This     is    the    Miracle")
      expect(query).to eq({
        filtered: {
          query: {
            multi_match: {
              query: "This is the Miracle",
              fields: ["_all"],
              operator: 'AND'
            }
          }
        }
      })
    end

    it 'will change query to match_all if query is blank' do
      expected_query =  { filtered: {
                            query: {
                                match_all: {}
                            }
                          }
                        }
      query = IKit::TestIkit::Searcher::People.get_query("")
      expect(query).to eq(expected_query)
      query = IKit::TestIkit::Searcher::People.get_query("      ")
      expect(query).to eq(expected_query)
      query = IKit::TestIkit::Searcher::People.get_query(nil)
      expect(query).to eq(expected_query)
    end
  end

  describe "has class's method get_paging" do
    it 'will return from = 0 and size = 10 if given blank hash' do
      paging = IKit::TestIkit::Searcher::People.get_paging({})
      expect(paging).to eq({ from: 0, size: 10 })
      paging = IKit::TestIkit::Searcher::People.get_paging(nil)
      expect(paging).to eq({ from: 0, size: 10 })
    end

    it 'will return from = 10 and size = 21 if given hash with from equal 10 and size equal 21' do
      paging = IKit::TestIkit::Searcher::People.get_paging({from: 10, size: 21})
      expect(paging).to eq({ from: 10, size: 21 })
    end

  end

  describe "has class's method get_sort" do
    it 'will return blank hash if given blank hash' do
      sort = IKit::TestIkit::Searcher::People.get_sort({})
      expect(sort).to eq({})
      sort = IKit::TestIkit::Searcher::People.get_sort(nil)
      expect(sort).to eq({})
    end

    it 'will return {:name => {:order => :desc} if given {:name => :desc}' do
      sort = IKit::TestIkit::Searcher::People.get_sort({:name => :desc})
      expect(sort).to eq({:name => { :order => :desc, missing: :_last }})
    end
  end



  describe 'has method get_records' do
    context 'which will return @person if' do
      it 'gives name = Miracle' do
        @searcher = IKit::TestIkit::Searcher::People.new 'Miracle'
        expect(@searcher.get_records.first).to eq(@person)
      end

      it 'gives not name (racl)' do
        @searcher = IKit::TestIkit::Searcher::People.new 'racl'
        results = @searcher.get_records
        expect(results.any?{|r| r.eql?(@person)}).to eq(true)
      end
    end

    it 'find all person if give blank string' do
      @searcher = IKit::TestIkit::Searcher::People.new ''
      results = @searcher.get_records
      expect(results.total).to eq(Person.count)
    end

    context 'which will not return @person if' do
      it 'gives name not equal Miracle' do
        @searcher = IKit::TestIkit::Searcher::People.new 'rtur'
        results = @searcher.get_records
        expect(results.any?{|r| r.eql?(@person)}).to eq(false)
      end
    end

    context 'can sort records by' do

      it "name.sort with asc direction" do
        @searcher = IKit::TestIkit::Searcher::People.new '', sort: { 'name.sort' => :asc }
      
        results = @searcher.get_records
        expect(results.first).to eq(@person_with_the_biggest_name)
      end

      it "name.sort with desc direction" do
        @searcher = IKit::TestIkit::Searcher::People.new '', sort: { "name.sort" => :desc }
      
        results = @searcher.get_records
        expect(results.first).to eq(@person_with_the_smallest_name)
      end
    end
  end

end
