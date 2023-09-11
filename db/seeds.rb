Role.create(name: 'Admin', code: 'ADMIN')
Role.create(name: 'Staff', code: 'STAFF')
Role.create(name: 'Supervisor', code: 'SUPERVISOR')

5.times do
    Organization.create(
      name: Faker::Name.unique.name,
      logo: "https://w7.pngwing.com/pngs/232/373/png-transparent-delaware-company-management-marketing-asset-random-buttons-company-text-comic-book.png",
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
    User.create(
      email: Faker::Internet.email,
      password: 'password', # Set a default password for all users
      profile_picture: "https://w7.pngwing.com/pngs/232/373/png-transparent-delaware-company-management-marketing-asset-random-buttons-company-text-comic-book.png",
      role_id: Role.all.sample.id,
      organization_id: Organization.all.sample.id,
      department_id: Department.all.sample.id
    )
  end

  1.times do
    AttendanceSetting.create(
      enable_live_location: true,
      enable_take_selfie: true,
      enable_auto_approval_attendance: true,
      organization_id: Organization.all.sample.id
    )
  end
