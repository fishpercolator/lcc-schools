class AddNotAllNearest < ActiveRecord::Migration
  def change
    add_column :schools, :not_all_nearest, :boolean
  end
end
