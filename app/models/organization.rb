class Organization < ApplicationRecord
    has_one_attached :logo
    has_many :users
    has_one :attendance_setting
    
    validate :acceptable_image

    def acceptable_image
        return unless profile_picture.attached?
      
        unless profile_picture.blob.byte_size <= 5.megabyte
          errors.add(:profile_picture, "is too big")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_picture.content_type)
          errors.add(:profile_picture, "must be a JPEG or PNG")
        end
      end
  
     def logo_url
      if logo.attached?
        Rails.application.routes.url_helpers.rails_blob_path(logo, only_path: true)
       end
     end
end
