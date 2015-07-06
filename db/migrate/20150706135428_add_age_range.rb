class AddAgeRange < ActiveRecord::Migration
  def change
    add_column :schools, :from_age, :integer
    add_column :schools, :to_age, :integer
  end
end
