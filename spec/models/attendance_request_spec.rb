require 'rails_helper'

RSpec.describe AttendanceRequest, type: :model do
  describe 'attendance request approval' do
    let(:staff_role) { Role.create(name: 'Staff', code: 'staff') }
    let(:supervisor_role) { Role.create(name: 'Supervisor', code: 'supervisor') }

    let(:organization) { Organization.create(name: 'Sample Org', description: 'Test Organization') }
    let(:department) { Department.create(name: 'Sample Department', description: 'Test Department', organization: organization) }

    let(:staff_user) do
      User.create(
        email: 'staff@example.com',
        password: 'PaSSw0RD123',
        role: staff_role,
        organization: organization,
        department: department
      )
    end

    let(:supervisor_user) do
      User.create(
        email: 'supervisor@example.com',
        password: 'PaSSw0RD123',
        role: supervisor_role,
        organization: organization,
        department: department
      )
    end

    it 'allows a staff user to request attendance and a supervisor to approve it' do
      attendance_request = AttendanceRequest.new(
        requested_by: staff_user,
        approved_by: nil, # Initially, approved_by is nil
        notes: 'Test notes',
        requested_at: Date.today,
        live_location: 'Sample Location',
        selfie_image: 'Sample Image',
        attendance_status: AttendanceStatus.new(name: 'Pending', code: 'pending')
      )

      expect(attendance_request.valid?).to be true
      attendance_request.save

      # Ensure the request is initially in a "Pending" status
      expect(attendance_request.attendance_status.name).to eq('Pending')

      # Now, simulate the supervisor approving the request
      attendance_request.approved_by = supervisor_user

      # Update the status in the database
      attendance_request.update(attendance_status: AttendanceStatus.find_by(name: 'Approved'))

      # Reload the record from the database to reflect the changes
      attendance_request.reload

      # Verify that the request is approved and the status is updated to "Approved"
      expect(attendance_request.approved_by).to eq(supervisor_user)
      expect(attendance_request.attendance_status.name).to eq('Approved')
    end
  end
end
