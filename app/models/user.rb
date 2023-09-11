class User < ApplicationRecord
    ROLES = %w(admin staff).freeze
    DEPARTMENTS = %w(hr tech business).freeze
  
    has_secure_password
  
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
    validates :role, presence: true, inclusion: { in: ROLES }
    validates :department, presence: true, inclusion: { in: DEPARTMENTS }
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
  