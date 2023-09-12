class Organization < ApplicationRecord
    has_one_attached :logo
    has_many :users
    has_one :attendance_setting
end
