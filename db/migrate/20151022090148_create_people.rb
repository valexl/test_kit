class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :region
      t.string :city
      t.string :country
      t.string :credential
      t.string :earned
      t.string :status

      t.timestamps null: false
    end
  end
end
