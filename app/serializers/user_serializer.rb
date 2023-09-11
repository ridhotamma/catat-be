class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :profile_picture, :department, :organization, :role, :created_at, :updated_at

   def attributes(*args)
    super.except(:created_at, :updated_at)
  end

  def organization
    object.organization.as_json(except: [:created_at, :updated_at])
  end

  def department
    object.department.as_json(except: [:created_at, :updated_at])
  end

  def role
    object.role.as_json(except: [:created_at, :updated_at])
  end
end
