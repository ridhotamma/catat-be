Role.create(name: 'Admin', code: 'ADMIN')
Role.create(name: 'Staff', code: 'STAFF')
Role.create(name: 'Supervisor', code: 'SUPERVISOR')

AttendanceStatus.create(name: 'Approved', code: 'A')
AttendanceStatus.create(name: 'Rejected', code: 'R')
AttendanceStatus.create(name: 'Cancelled', code: 'C')
AttendanceStatus.create(name: 'Pending', code: 'P')

5.times do
    Organization.create(
      name: Faker::Name.unique.name,
      description: Faker::Company.catch_phrase
    )
  end


  10.times do
    Department.create(
      name: Faker::Name.unique.name,
      description: Faker::Lorem.sentence,
      organization_id: Organization.all.sample.id
    )
  end

  20.times do
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

  1.times do
    AttendanceSetting.create(
      enable_live_location: true,
      enable_take_selfie: true,
      enable_auto_approval_attendance: true,
      organization_id: Organization.all.sample.id
    )
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