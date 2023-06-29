class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|

      t.integer :worker_id, null: false
      t.timestamp :start_worktime
      t.timestamp :finish_worktime
      t.timestamp :start_breaktime
      t.timestamp :finish_breaktime
      t.string :comment
      t.integer :reason_status, default: 0, null: false

      t.timestamps
    end
  end
end
