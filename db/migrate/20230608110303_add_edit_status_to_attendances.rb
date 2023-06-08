class AddEditStatusToAttendances < ActiveRecord::Migration[6.1]
  def change
    add_column :attendances, :edit_status, :integer, default: 0, null: false
  end
end
