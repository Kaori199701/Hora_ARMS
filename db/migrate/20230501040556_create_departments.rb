class CreateDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :departments do |t|

      t.string :department_code, null: false
      t.string :department_name, null: false

      t.timestamps
    end
  end
end
