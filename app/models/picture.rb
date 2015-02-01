class Picture < ActiveRecord::Base
  belongs_to :album
  has_attached_file :photo, styles: {medium: "500x500>", large: "700x700>"}
  validates_attachment :photo, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}

end
