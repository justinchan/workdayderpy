class ChangeStuff < ActiveRecord::Migration
  def change
  	remove_column :pictures, :url
  	add_column :pictures, :name, :string
  end
end
