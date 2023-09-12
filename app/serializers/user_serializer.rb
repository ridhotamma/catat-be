class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :profile_picture_url

  belongs_to :organization, only: [:name]
  belongs_to :department, only: [:name]
  belongs_to :role, only: [:name]
end
