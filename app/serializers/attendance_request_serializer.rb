class AttendanceRequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :requested_datetime, :requested_by, :approved_by, :notes, :location, :selfie_image_url

  belongs_to :requested_by
  belongs_to :approved_by

  def location
    {
      latitude: object.latitude,
      longitude: object.longitude
    }
  end

  def requested_datetime
    {
      clock_in_datetime: object.clock_in,
      clock_in_datetime_formatted: object.clock_in&.strftime("%B %dth %Y"),
      clock_out_datetime: object.clock_out,
      clock_out_datetime_formatted: object.clock_out&.strftime("%B %dth %Y")
    }
  end

  def status
    {
      status_name: object.attendance_status&.name,
      status_code: object.attendance_status&.code,
      is_rejected: object.attendance_status&.code == "R",
      is_pending: object.attendance_status&.code == "P",
      is_approved: object.attendance_status&.code == "A",
      is_cancelled: object.attendance_status&.code == "C"
    }
  end

  def requested_by
    {
      email: object.requested_by&.email,
      first_name: object.requested_by&.first_name,
      last_name: object.requested_by&.last_name,
      user_id: object.requested_by&.id,
      role: object.requested_by&.role&.name
    }
  end

  def approved_by
    {
      email: object.approved_by&.email,
      first_name: object.approved_by&.first_name,
      last_name: object.approved_by&.last_name,
      user_id: object.approved_by&.id,
      role: object.approved_by&.role&.name
    }
  end
end
