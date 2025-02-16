class AddIndexToAuths < ActiveRecord::Migration[8.0]
  def change
    add_index :auths, :email, unique: true
    add_index :auths, :reset_password_token, unique: true
  end
end
