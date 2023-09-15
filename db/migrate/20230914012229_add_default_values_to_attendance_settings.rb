class AddDefaultValuesToAttendanceSettings < ActiveRecord::Migration[7.0]
  def change
    change_column_default :attendance_settings, :enable_live_location, false
    change_column_default :attendance_settings, :enable_take_selfie, false
    change_column_default :attendance_settings, :enable_auto_approval_attendance, false
    change_column_default :attendance_settings, :enable_one_request_per_day, false
    change_column_default :attendance_settings, :max_radius, 1000
  end
end
