class Organization < ApplicationRecord
    has_many :users
    has_one :attendance_setting
end
