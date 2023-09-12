class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :profile_picture_url, :organization, :department
end
