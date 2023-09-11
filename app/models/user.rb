class User < ApplicationRecord
    belongs_to :role
    belongs_to :organization
    belongs_to :department
    
    has_secure_password
  
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
    validates :password, presence: true, length: { minimum: 8 }
    validate :password_complexity
  
    private
  
    def password_complexity
      return if password.blank?
  
      unless password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
        errors.add(:password, 'must include at least one lowercase letter, one uppercase letter, and one digit')
      end
    end
  end
  