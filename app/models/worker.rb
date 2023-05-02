class Worker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :department
  belongs_to :director
  belongs_to :location
  belongs_to :working_hour

  enum employment_status: { tenure: 0, retirement: 1, leave_from_work: 2 }
  enum sex: { male: 0, female: 1}

end
