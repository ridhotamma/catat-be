class AttendanceStatus < ApplicationRecord
    has_many :attendance_request
end
