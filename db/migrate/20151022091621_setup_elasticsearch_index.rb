class SetupElasticsearchIndex < ActiveRecord::Migration
  def change
    puts 'DELETE INDEX'
    Person.__elasticsearch__.delete_index! rescue nil

    puts 'CREATE INDEX'
    Person.__elasticsearch__.create_index!

    puts 'IMPORT DATA'
    Person.__elasticsearch__.import
  end
end
