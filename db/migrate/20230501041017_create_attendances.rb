class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|

      t.integer :workers_id, null: false
      t.integer :working_hour_id, null: false
      t.timestamp :start_worktime
      t.timestamp :finish_worktime
      t.timestamp :start_breaktime
      t.timestamp :finish_breaktime
      t.string :comment
      t.integer :year_status, default: 0, null: false
      t.integer :month_status, default: 0, null: false
      t.integer :reason_status, default: 0, null: false

      t.timestamps
    end
  end
end
