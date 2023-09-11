class AddAttendanceStatusToAttendanceRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendance_requests, :attendance_status, null: false, foreign_key: true
  end
end
