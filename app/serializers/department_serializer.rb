class DepartmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  belongs_to :organization
end
