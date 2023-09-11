class CreateAttendanceSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :attendance_settings do |t|
      t.boolean :enable_live_location
      t.boolean :enable_take_selfie

      t.timestamps
    end
  end
end
