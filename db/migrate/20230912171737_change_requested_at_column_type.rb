class ChangeRequestedAtColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :attendance_requests, :requested_at, :datetime
  end
end
