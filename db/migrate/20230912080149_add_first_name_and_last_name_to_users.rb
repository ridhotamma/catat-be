class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    change_column_null :users, :organization_id, true
    change_column_null :users, :department_id, true
  end
end
