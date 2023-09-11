class Department < ApplicationRecord
    has_many :users
    validates_presence_of :organization_id
    validates_presence_of :name
end
