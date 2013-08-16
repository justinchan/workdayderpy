class ChangeStuff < ActiveRecord::Migration
  def change
  	remove_column :pictures, :url
  	add_coumn :pictures, :name
  end
end
