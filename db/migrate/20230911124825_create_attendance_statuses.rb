class CreateAttendanceStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :attendance_statuses do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
