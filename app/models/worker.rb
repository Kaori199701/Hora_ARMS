class Worker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:employee_number]

  belongs_to :department
  belongs_to :director
  belongs_to :location
  belongs_to :working_hour, optional: true
  has_many :attendances

  def full_name
    self.last_name + self.first_name
  end

  def self.search(search)
    if search
      workers = Worker.all.map{|worker| [worker.full_name, worker.id] }

      searched_worker_ids = []
 
      workers.each do |worker|
        if worker[0].include?(search)
          searched_worker_ids << worker[1]
        end
      end
      Worker.where(id: searched_worker_ids)
    else
      Worker.all
    end
  end

  enum employment_status: { tenure: 0, retirement: 1, leave_from_work: 2 }
  enum sex: { male: 0, female: 1}

end
