class AttendanceRequest < ApplicationRecord
  belongs_to :attendance_status, class_name: 'AttendanceStatus', foreign_key: 'attendance_status_id'
  belongs_to :requested_by, class_name: 'User', foreign_key: 'requested_by_id'
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
end
