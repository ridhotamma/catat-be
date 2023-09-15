class Department < ApplicationRecord
    has_many :users
    belongs_to :organization

    validates :name, presence: true, uniqueness: true
end
