class AddMaxRadiusAttendance < ActiveRecord::Migration[7.0]
  def change
    add_column :attendance_settings, :max_radius, :integer, default: 0
  end
end
