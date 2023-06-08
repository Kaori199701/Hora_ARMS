class Attendance < ApplicationRecord

  belongs_to :worker

  enum reason_status: { nothing: 0, paid_holiday: 1, absenteeism: 2, business_trip: 3, special_holiday: 4, maternity_leave: 5, childcare_leave: 6 }
  enum edit_status: { no_edit: 0, admin_edited: 1, worker_edited:2 }

    #出退勤情報の表示
  def status
    if finish_worktime.present?    #退勤がある場合→「退勤」と表示
      "退勤"
    elsif start_worktime.present?    #出勤があって退勤がない場合→「出勤」と表示
      "出勤"
    else #なにもない場合

    end
  end

end
