class AttendanceSetting < ApplicationRecord
  belongs_to :organization
  validates_uniqueness_of :organization_id, on: :create
end
