class WorkingHour < ApplicationRecord

  has_many :workers

  validates :working_hour_code, presence:true
  validates :start_working_hour, presence:true
  validates :finish_working_hour, presence:true

end
