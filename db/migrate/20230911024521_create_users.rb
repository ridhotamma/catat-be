class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :profile_picture
      t.string :department
      t.string :role

      t.timestamps
    end
  end
end
