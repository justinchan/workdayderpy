class Picture < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :url
  has_attached_file :actual_picture, :storage => :dropbox, :dropbox_credentials => Rails.root.join("config/dropbox.yml"), :path => "/:username.:extension"

  def picture_from_url(url_parm)
  	self.actual_picture = URI.parse(url_parm)
  end
  
  Paperclip.interpolates :username do |attachment, style|
    attachment.instance.url
  end
end
