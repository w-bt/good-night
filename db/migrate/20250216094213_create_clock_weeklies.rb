class CreateClockWeeklies < ActiveRecord::Migration[6.1]
  def change
    create_table :clock_weeklies, id: :uuid  do |t|
      t.uuid :user_id, null: false
      t.date :week_start, null: false
      t.integer :total_duration, default: 0, null: false
      t.timestamps
    end
  end
end
