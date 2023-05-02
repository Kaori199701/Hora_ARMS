class Department < ApplicationRecord

  has_many :workers

  validates :department_code, presence:true
  validates :department_name, presence:true

end
