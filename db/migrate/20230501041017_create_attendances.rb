class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|

      t.integer :workers_id, null: false
      t.integer :working_hour_id, null: false
      t.time :start_worktime, null: false
      t.time :finish_worktime, null: false
      t.time :start_breaktime, null: false
      t.time :finish_breaktime, null: false
      t.string :comment, null: false
      t.integer :year_status, default: 0, null: false
      t.integer :month_status, default: 0, null: false
      t.integer :reason_status, default: 0, null: false

      t.timestamps
    end
  end
end
