class AddIndexToClocks < ActiveRecord::Migration[8.0]
  def change
    add_index :clocks, [ :user_id, :clock_in ], unique: true, where: 'clock_in IS NULL'
    add_index :clocks, [ :user_id, :clock_out ], unique: true, where: 'clock_out IS NULL'
    add_index :clocks, [ :user_id, :clock_in, :clock_out ], unique: true, where: 'clock_in IS NULL AND clock_out IS NULL'
  end
end
