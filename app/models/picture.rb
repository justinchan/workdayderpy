class Picture < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :url
  has_attached_file :actual_picture, :storage => :dropbox, :dropbox_credentials => Rails.root.join("config/dropbox.yml"), :path => "/:url.:extension"

  def picture_from_url(url)
  	self.actual_picture = URI.parse(url)
  end
  
  Paperclip.interpolates :username do |attachment, style|
    attachment.instance.url
  end
end
