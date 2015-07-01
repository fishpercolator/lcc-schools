class AddNearest < ActiveRecord::Migration
  def change
    add_column :schools, :nearest, :float
    add_column :schools, :non_nearest, :float
  end
end
