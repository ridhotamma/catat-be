class AddUniqueConstraintToRoleAndAttendanceStatus < ActiveRecord::Migration[7.0]
  def change
    add_index :roles, :name, unique: true
    add_index :roles, :code, unique: true
    add_index :attendance_statuses, :name, unique: true
    add_index :attendance_statuses, :code, unique: true
  end
end
