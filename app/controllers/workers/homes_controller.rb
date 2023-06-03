class Workers::HomesController < ApplicationController
  def top
    @attendance = Attendance.new
    @worker = current_worker
    @attendances = Attendance.where(worker_id: @worker.id)
    @current_md = Date.current

    attendances = Attendance.where(worker_id: @worker.id).where("stamp_date >= ?", DateTime.now.at_beginning_of_month).where("stamp_date <= ?", DateTime.now.at_end_of_month)
    day_num = DateTime.now.at_end_of_month.day
    start_worktimes = attendances.pluck(:start_worktime)
    finish_worktimes = attendances.pluck(:finish_worktime)
    start_breaktimes = attendances.pluck(:start_breaktime)
    finish_breaktimes = attendances.pluck(:finish_breaktime)

    @errors = []

    if start_worktimes.select(&:itself).size < day_num || finish_worktimes.select(&:itself).size < day_num || start_breaktimes.select(&:itself).size < day_num || finish_breaktimes.select(&:itself).size < day_num
            #打刻した日数が、月の日数より少ない場合
      @attendances.each do |attendance|

        error_attendance = false

        if attendance.start_worktime.nil?
          error_attendance = true
        end

        if attendance.finish_worktime.nil?
          error_attendance = true
        end

        if attendance.start_breaktime.nil?
          error_attendance = true
        end

        if attendance.finish_breaktime.nil?
          error_attendance = true
        end

        if error_attendance
          @errors.push(@current_md.strftime("%Y年%m月%d日")+"に打刻漏れがあります。") #stamp_dateの月日を表示+"に打刻漏れがあります。(1か月単位？)"
        end
      end

    else

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