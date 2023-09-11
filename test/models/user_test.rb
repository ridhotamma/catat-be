require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: 'test@example.com',
      password: 'Password123',
      role: 'admin',
      department: 'hr'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email should have a valid format' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email should reject invalid formats' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'role should be present' do
    @user.role = '   '
    assert_not @user.valid?
  end

  test 'role should be valid' do
    valid_roles = %w[admin staff]
    valid_roles.each do |valid_role|
      @user.role = valid_role
      assert @user.valid?, "#{valid_role.inspect} should be valid"
    end
  end

  test 'role should reject invalid roles' do
    invalid_roles = %w[manager engineer]
    invalid_roles.each do |invalid_role|
      @user.role = invalid_role
      assert_not @user.valid?, "#{invalid_role.inspect} should be invalid"
    end
  end

  test 'department should be present' do
    @user.department = '   '
    assert_not @user.valid?
  end

  test 'department should be valid' do
    valid_departments = %w[hr tech business]
    valid_departments.each do |valid_department|
      @user.department = valid_department
      assert @user.valid?, "#{valid_department.inspect} should be valid"
    end
  end

  test 'department should reject invalid departments' do
    invalid_departments = %w[finance marketing]
    invalid_departments.each do |invalid_department|
      @user.department = invalid_department
      assert_not @user.valid?, "#{invalid_department.inspect} should be invalid"
    end
  end

  test 'password should be present' do
    @user.password = ' ' * 8
    assert_not @user.valid?
  end

  test 'password should have a minimum length of 8 characters' do
    @user.password = 'Passwrd'
    assert_not @user.valid?
  end

  test 'password should include at least one lowercase letter, one uppercase letter, and one digit' do
    @user.password = 'password'
    assert_not @user.valid?

    @user.password = 'PASSWORD'
    assert_not @user.valid?

    @user.password = 'Password'
    assert_not @user.valid?

    @user.password = '12345678'
    assert_not @user.valid?

    @user.password = 'Passw0rd'
    assert @user.valid?
  end
end
