class ChangeLatitudeAndLongitudeToFloatInAttendanceRequests < ActiveRecord::Migration[6.0] # Use your Rails version
  def change
    change_column :attendance_requests, :latitude, 'double precision USING CAST(latitude AS double precision)'
    change_column :attendance_requests, :longitude, 'double precision USING CAST(latitude AS double precision)'
  end
end
