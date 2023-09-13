class RenameRequestedAtAndAddClockOutToAttendanceRequests < ActiveRecord::Migration[6.0]
  def change
    rename_column :attendance_requests, :requested_at, :clock_in
    add_column :attendance_requests, :clock_out, :datetime
  end
end
