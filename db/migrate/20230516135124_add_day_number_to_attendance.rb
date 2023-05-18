class AddDayNumberToAttendance < ActiveRecord::Migration[6.1]
  def change
    add_column :attendances, :stamp_date, :date, null: false
  end
end
