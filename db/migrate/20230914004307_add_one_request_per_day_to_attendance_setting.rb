class AddOneRequestPerDayToAttendanceSetting < ActiveRecord::Migration[7.0]
  def change
    add_column :attendance_settings, :enable_one_request_per_day, :boolean, default: false
  end
end
