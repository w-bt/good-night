class AddIndexToClockWeeklies < ActiveRecord::Migration[8.0]
  def change
    add_index :clock_weeklies, [ :user_id, :week_start ], unique: true
  end
end
