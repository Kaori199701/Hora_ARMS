class CreateWorkingHours < ActiveRecord::Migration[6.1]
  def change
    create_table :working_hours do |t|

      t.string :working_hour_code, null: false
      t.timestamp :start_working_hour, null: false
      t.timestamp :finish_working_hour, null: false

      t.timestamps
    end
  end
end
