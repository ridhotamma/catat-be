class AddEnableAutoApprovalAttendanceToAttendanceSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :attendance_settings, :enable_auto_approval_attendance, :boolean
  end
end
