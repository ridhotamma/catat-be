class RemoveTakeSelfieFromAttendanceRequest < ActiveRecord::Migration[7.0]
  def change
    remove_column :attendance_requests, :selfie_image, :string
  end
end
