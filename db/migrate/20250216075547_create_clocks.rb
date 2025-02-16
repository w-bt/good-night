class CreateClocks < ActiveRecord::Migration[8.0]
  def change
    create_table :clocks, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :clock_in
      t.datetime :clock_out
      t.integer :duration, default: -1

      t.timestamps
    end
  end
end
