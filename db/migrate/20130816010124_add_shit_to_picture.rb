class AddShitToPicture < ActiveRecord::Migration
  def change
  	add_column :pictures, :url, :string
  	add_attachment :pictures, :actual_picture
  end
end
