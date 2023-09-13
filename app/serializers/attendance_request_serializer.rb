class AttendanceRequestSerializer < ActiveModel::Serializer
  attributes :id, :is_pending, :is_rejected, :is_approved, :attendance_status, :requested_datetime, :attendance_status_code, :requested_by, :approved_by, :notes, :live_location, :selfie_image
  
  belongs_to :requested_by
  belongs_to :approved_by

 
  def requested_datetime
    {
      clock_in_datetime: object.clock_in,
      clock_in_datetime_formatted: object.clock_in&.strftime('%Y-%m-%d %H:%M:%S'),
      clock_out_datetime: object.clock_out,
      clock_out_datetime_formatted: object.clock_out&.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  def attendance_status
    object.attendance_status&.name
  end

  def attendance_status_code
    object.attendance_status&.code
  end

  def is_rejected
    object.attendance_status&.code == 'R'
  end

  def is_pending
    object.attendance_status&.code == 'P'
  end

  def is_approved
    object.attendance_status&.code == 'A'
  end

  def requested_by
    {
      email: object.requested_by&.email,
      first_name: object.requested_by&.email,
      last_name: object.requested_by&.last_name,
      id: object.requested_by&.id,
      role: object.requested_by&.role&.name
    }
  end

  def approved_by
    {
      email: object.approved_by&.email,
      first_name: object.approved_by&.email,
      last_name: object.approved_by&.last_name,
      id: object.approved_by&.id,
      role: object.approved_by&.role&.name
    }
  end
  
end
