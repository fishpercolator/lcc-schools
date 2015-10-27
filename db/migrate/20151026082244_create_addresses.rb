class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name_or_number
      t.string :postcode
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
