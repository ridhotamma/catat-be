class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role.code
    when 'ADMIN'
      can :manage, :all
    when 'SUPERVISOR'
      can :manage, :all
    when 'STAFF'
      can :manage, :all
    end
  end
end
