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

  enum employment_status: { tenure: 0, retirement: 1, leave_from_work: 2 }
  enum sex: { male: 0, female: 1}


#　新規登録の時にエラーが出る用バリデーション
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :employee_number, presence: true



  def active_for_authentication?
    super && employment_status != 'retirement'
  end

  def full_name
    self.last_name + self.first_name
  end

  def current_attendance
    attendances.find_by(start_worktime: ..Time.current, stamp_date: Date.current)
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

end
