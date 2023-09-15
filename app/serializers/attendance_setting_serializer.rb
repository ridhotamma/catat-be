class AttendanceSettingSerializer < ActiveModel::Serializer
  attributes :enable_live_location, :enable_take_selfie, :enable_auto_approval_attendance, :enable_one_request_per_day
end
