Role.find_or_create_by(name: 'Admin', code: 'ADMIN')
Role.find_or_create_by(name: 'Staff', code: 'STAFF')
Role.find_or_create_by(name: 'Supervisor', code: 'SUPERVISOR')

AttendanceStatus.find_or_create_by(name: 'Approved', code: 'A')
AttendanceStatus.find_or_create_by(name: 'Rejected', code: 'R')
AttendanceStatus.find_or_create_by(name: 'Cancelled', code: 'C')
AttendanceStatus.find_or_create_by(name: 'Pending', code: 'P')

Organization.create(
  name: 'Yayasan Quadra',
  description: 'Panti Asuhan untuk calon programmer',
  latitude: 37.7749, 
  longitude: -122.4194,
)

AttendanceSetting.create(
  enable_live_location: true,
  enable_take_selfie: false,
  enable_auto_approval_attendance: false,
  organization_id: Organization.all.sample.id
)

Department.create(
  name: 'Kesenian',
  description: 'Mengurus kegiatan yg berkaitan dengan kesenian',
  organization_id: 1
)

Department.create(
  name: 'Kesehatan',
  description: 'Mengurus urusan terkait kesehatan',
  organization_id: 1
)

Department.create(
  name: 'Rohani',
  description: 'Mengurus kegiatan yg berkaitan dengan kerohanian',
  organization_id: 1
)

  5.times do
    user = User.create(
      first_name: Faker::Name.unique.name,
      last_name: Faker::Name.unique.name,
      email: Faker::Internet.email,
      password: 'Password123',
      role_id: Role.all.sample.id,
      organization_id: Organization.all.sample.id,
      department_id: Department.all.sample.id
    )
    user.profile_picture.attach(io: File.open(Rails.root.join('assets', 'avatar-default.jpeg')),
    filename: 'default_profile_picture.jpg',
    content_type: 'image/jpeg')
  end

  user = User.create(
    first_name: 'Ridho',
    last_name: 'Tamma',
    email: 'ridhotamma@gmail.com',
    password: 'Admin123',
    role_id: Role.find_by(code: 'ADMIN').id,
    organization_id: Organization.all.sample.id,
    department_id: Department.all.sample.id
  )
  user.profile_picture.attach(io: File.open(Rails.root.join('assets', 'avatar-default.jpeg')),
  filename: 'default_profile_picture.jpg',
  content_type: 'image/jpeg')

  AttendanceRequest.create(
    requested_by_id: 1,
    approved_by_id: 2,
    notes: "Sample attendance request 1",
    clock_in: Time.now - 2.hours,
    attendance_status_id: 3,
    clock_out: Time.now - 1.hour,
    latitude: 37.7749, 
    longitude: -122.4194,
  )