class Director < ApplicationRecord

  has_many :workers

  validates :director_code, presence:true
  validates :director_name, presence:true
end
