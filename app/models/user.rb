class User < ApplicationRecord
    attr_accessor :changing_password
    has_one_attached :profile_picture

    belongs_to :role
    belongs_to :organization, optional: true
    belongs_to :department, optional: true
    
    has_secure_password
  
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
    validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
    validate :password_complexity
    validate :acceptable_image

    private
  
    def password_required?
      changing_password || new_record?
    end

    def password_complexity
      return if password.blank?
  
      unless password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
        errors.add(:password, 'must include at least one lowercase letter, one uppercase letter, and one digit')
      end
    end
    
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

   def profile_picture_url
    if profile_picture.attached?
      Rails.application.routes.url_helpers.rails_blob_path(profile_picture, only_path: true)
     end
   end

end
  