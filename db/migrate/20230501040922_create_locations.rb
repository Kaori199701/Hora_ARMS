class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|

      t.string :location_code, null: false
      t.string :location_name, null: false

      t.timestamps
    end
  end
end
