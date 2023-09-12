class RemoveImageFromUserAndOrganization < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :profile_picture, :string
    remove_column :organizations, :logo, :string
  end
end
