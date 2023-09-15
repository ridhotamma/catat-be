class Organization < ApplicationRecord
    has_one_attached :logo
    has_many :users
    has_one :attendance_setting
    
    validate :acceptable_image

    after_create :create_default_attendance_setting

    def acceptable_image
        return unless logo.attached?
      
        unless logo.blob.byte_size <= 5.megabyte
          errors.add(:logo, "is too big")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(logo.content_type)
          errors.add(:logo, "must be a JPEG or PNG")
        end
      end
  
     def logo_url
      if logo.attached?
        ActiveStorage::Blob.service.path_for(logo.key)
      else
        Rails.root.join('assets', 'organization-default.jpeg')
      end
     end

     # build attendance_setting when created
     def create_default_attendance_setting
      unless attendance_setting
        self.build_attendance_setting(
          enable_live_location: true,
          enable_take_selfie: true,
          enable_auto_approval_attendance: true
        ).save
      end
    end
end
