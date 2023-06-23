class Workers::HomesController < ApplicationController
before_action :authenticate_worker!


  def top
    @attendance = Attendance.new
    @worker = current_worker
    @attendances = Attendance.where(worker_id: @worker.id)

    @errors = []

    # レコードが無い日 -> エラー対象
    # レコードがあるけど打刻が足りてない日 -> エラー対象
    # レコードがあって打刻が揃っている日 -> エラー対象外
    velified_attendances = Attendance.where(worker_id: @worker.id)
      .where("stamp_date >= ?", DateTime.now.at_beginning_of_month)
      .where("stamp_date <= ?", DateTime.now.end_of_day)
      .where.not(start_worktime: nil)
      .where.not(finish_worktime: nil)
      .where.not(start_breaktime: nil)
      .where.not(finish_breaktime: nil)
    work_days = (Date.today.beginning_of_month..Date.today).to_a
    error_days = work_days - velified_attendances.pluck(:stamp_date)

    error_days.each do |error_day|


    attendance = current_worker.attendances.find_by(stamp_date: error_day)
      if attendance&.reason_status == "paid_holiday" ||
         attendance&.reason_status == "absenteeism" ||
         attendance&.reason_status == "special_holiday" ||
         attendance&.reason_status == "maternity_leave" ||
         attendance&.reason_status == "childcare_leave" ||
         error_day.wday == 0 ||
         error_day.wday == 6
           #土日は省く
         #@current_month[i-1][:weekday_jp].include?("(土)")
            next
      end

      if attendance&.start_worktime.nil? || attendance.finish_worktime.nil? || attendance.start_breaktime.nil? || attendance.finish_breaktime.nil?
        @errors.push(error_day&.strftime("%Y年%m月%d日")+"に打刻漏れがあります。")
      end

    end
  end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.save
    redirect_to workers_attendances_path
  end


private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end