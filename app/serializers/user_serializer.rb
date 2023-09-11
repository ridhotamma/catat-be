class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :profile_picture, :department, :role, :created_at, :updated_at

  def password_digest
    nil
  end
end
