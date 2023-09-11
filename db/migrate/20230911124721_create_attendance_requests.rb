class CreateAttendanceRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :attendance_requests do |t|
      t.references :requested_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.string :notes
      t.date :requested_at
      t.string :live_location
      t.string :selfie_image

      t.timestamps
    end
  end
end
