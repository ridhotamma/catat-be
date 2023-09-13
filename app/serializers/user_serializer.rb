class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :role, :email, :profile_picture_url, :organization, :department

  belongs_to :role
  belongs_to :organization
end
