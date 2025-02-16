class AddIndexToClockDailies < ActiveRecord::Migration[8.0]
  def change
    add_index :clock_dailies, [ :user_id, :date ], unique: true
  end
end
