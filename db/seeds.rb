User.create(email: 'admin@example.com', password: 'password', role: 'admin')
User.create(email: 'staff@example.com', password: 'password', role: 'staff')
User.create(email: 'admin@admin.com', password: 'password', role: 'admin')
User.create(email: 'staff@staff.com', password: 'staff', role: 'staff')

AttendanceSetting.create(
    enable_live_location: true,
    enable_take_selfie: false
)
