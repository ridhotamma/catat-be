class RenameLiveLocationToLatitudeAndLongitude < ActiveRecord::Migration[7.0]
  def change
    remove_column :attendance_requests, :live_location, :string
    add_column :attendance_requests, :latitude, :string
    add_column :attendance_requests, :longitude, :string
  end
end
