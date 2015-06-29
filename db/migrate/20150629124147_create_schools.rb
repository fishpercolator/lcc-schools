class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :code
      t.string :name
      t.string :phase
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :telephone
      t.string :postcode
      t.string :headteacher
      t.integer :number_of_pupils
      t.st_point :centroid
      t.string :telephone
      t.string :email
      t.string :website
      t.string :ofsted_report
      t.integer :available_places
      t.integer :number_of_admissions

      t.timestamps null: false
    end
  end
end
