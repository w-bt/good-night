class CreateAuths < ActiveRecord::Migration[8.0]
  def change
    create_table :auths, id: :uuid  do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps
    end
  end
end
