# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role.code
    when 'ADMIN'
      can :manage, :all
    when 'SUPERVISOR'
      can [:read, :create, :update], Api::V1::AttendanceRequestsController
      can [:approve, :reject], Api::V1::AttendanceRequestsController
    when 'STAFF'
      can [:read, :create], Api::V1::AttendanceRequestsController
    end
  end
end
