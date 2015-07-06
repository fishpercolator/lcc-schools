class AddPriorities < ActiveRecord::Migration
  def change
    add_column :schools, :priority1a, :integer
    add_column :schools, :priority1b, :integer
    add_column :schools, :priority2,  :integer
    add_column :schools, :priority3,  :integer
    add_column :schools, :priority4,  :integer
    add_column :schools, :priority5,  :integer
  end
end
