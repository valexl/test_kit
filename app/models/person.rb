class Person < ActiveRecord::Base
  include Searchable

  settings do
    mapping do
      indexes :name, type: 'multi_field' do
        indexes :name, boost: 10
        indexes :sort, analyzer: 'sortable'
      end      

      indexes :city, type: 'multi_field' do
        indexes :city, boost: 10
        indexes :sort, analyzer: 'sortable'
      end      

      indexes :region, type: 'multi_field' do
        indexes :region, boost: 10
        indexes :sort, analyzer: 'sortable'
      end      
    end
  end
  
end
