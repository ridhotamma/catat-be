class AddOrganizationToAttendanceSettings < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendance_settings, :organization, null: false, foreign_key: true
  end
end
