class AddSchoolType < ActiveRecord::Migration
  def change
    add_column :schools, :type, :string
  end
end
