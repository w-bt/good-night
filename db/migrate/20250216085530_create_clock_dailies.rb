class CreateClockDailies < ActiveRecord::Migration[8.0]
  def change
    create_table :clock_dailies, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.date :date, null: false
      t.integer :total_duration, default: 0, null: false
      t.timestamps
    end
  end
end
