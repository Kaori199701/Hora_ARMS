class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|

      t.integer :worker_id, null: false
      t.datetime :start_worktime
      t.datetime :finish_worktime
      t.datetime :start_breaktime
      t.datetime :finish_breaktime
      t.string :comment
      t.integer :reason_status, default: 0, null: false

      t.timestamps
    end
  end
end
