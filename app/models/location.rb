class Location < ApplicationRecord

  has_many :workers

  validates :location_code, presence:true
  validates :location_name, presence:true

end
