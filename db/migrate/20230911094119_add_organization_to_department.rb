class AddOrganizationToDepartment < ActiveRecord::Migration[7.0]
  def change
    add_reference :departments, :organization, null: false, foreign_key: true
  end
end
