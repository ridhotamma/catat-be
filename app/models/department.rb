class Department < ApplicationRecord
    has_many :users
    belongs_to :organization
    
    validates_presence_of :organization_id
    validates_presence_of :name
end
