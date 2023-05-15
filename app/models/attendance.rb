class Attendance < ApplicationRecord

  belongs_to :worker

  enum reason_status: { nothing: 0, paid_holiday: 1, absenteeism: 2, business_trip: 3, special_holiday: 4, maternity_leave: 5, childcare_leave: 6 }

end
