class CreateDirectors < ActiveRecord::Migration[6.1]
  def change
    create_table :directors do |t|

      t.string :director_code, null: false
      t.string :director_name, null: false

      t.timestamps
    end
  end
end
