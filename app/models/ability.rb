class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role.code == 'ADMIN'
      can :manage, AttendanceRequest
      can :manage, User
      can :manage, Role
      can :manage, Department
      can :manage, Organization
      can :manage, AttendanceSetting
      
    elsif user.role.code == 'SUPERVISOR'
      can [:index, :show, :approve, :reject], AttendanceRequest
      can :manage, User
      can [:index, :show], Role
      can :manage, Department
      can [:show], Organization
      can :manage, AttendanceSetting

    elsif user.role.code == 'STAFF'
      can [:index, :show, :cancel], AttendanceRequest
      can [:profile], User
      cannot :manage, Role
      cannot :manage, Department
      cannot :manage, Organization
      cannot :manage, AttendanceSetting
    end
  end
end
