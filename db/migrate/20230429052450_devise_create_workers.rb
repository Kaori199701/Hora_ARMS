# frozen_string_literal: true

class DeviseCreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false

      t.integer :department_id, null: false
      t.integer :location_id, null: false
      t.integer :director_id, null: false
      t.integer :working_hour_id, null: false
      t.string :employee_number, null: false
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :last_name_kana, null: false
      t.string :first_name_kana, null: false
      t.integer :sex,  default: 0, null: false
      t.date :birthday, null: false
      t.date :hire_date, null: false
      t.date :retirement_date, null: false
      t.date :start_career_break, null: false
      t.date :finish_career_break, null: false
      t.integer :employment_status, default: 0, null: false

    end

    add_index :workers, :email,                unique: true
    add_index :workers, :reset_password_token, unique: true
    # add_index :workers, :confirmation_token,   unique: true
    # add_index :workers, :unlock_token,         unique: true
  end
end
