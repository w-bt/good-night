class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, id: :uuid  do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :followee, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
