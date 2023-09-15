class AttendanceRequest < ApplicationRecord
  has_one_attached :selfie_image

  belongs_to :attendance_status, class_name: 'AttendanceStatus', foreign_key: 'attendance_status_id'
  belongs_to :requested_by, class_name: 'User', foreign_key: 'requested_by_id'
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true

  def within_organization_radius?
    organization = self.requested_by.organization
    return false if organization.blank?

    distance = Geocoder::Calculations.distance_between(
      [self[:latitude], self[:longitude]],
      [organization.latitude, organization.longitude]
    )

    max_radius = organization.attendance_setting.max_radius

    distance <= max_radius
  end

  def self_and_organization_location
    organization = self.requested_by.organization

    distance = Geocoder::Calculations.distance_between(
      [self[:latitude], self[:longitude]],
      [organization.latitude, organization.longitude]
    )

    {
      attendance_latitude:  self[:latitude],
      attendance_longitude: self[:longitude],
      organization_latitude: organization.latitude,
      organization_longitude: organization.longitude,
      distance: distance
    }

  end

  def selfie_image_url
    if selfie_image.attached?
      ActiveStorage::Blob.service.path_for(selfie_image.key)
    else
      Rails.root.join('assets', 'avatar-default.jpeg')
    end
   end
end
