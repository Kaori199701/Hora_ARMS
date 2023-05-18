class Workers::AttendancesController < ApplicationController
  def index
    @workers = Worker.all
    @worker = current_worker
  end


  def show
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def edit
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def update
    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current
    number_of_month = @today.end_of_month.day
    t = params["worker"]

    year =  @today.year
    month = @today.month
    number_of_month.times do |i|
      i += 1
      day = i
      if t["id"][i.to_s].present?
        attendance = Attendance.find(t["id"][i.to_s])
        start_time = t["start_worktime"][i.to_s]
        finish_time = t["finish_worktime"][i.to_s]
        start_breaktime = t["start_breaktime"][i.to_s]
        finish_breaktime = t["finish_breaktime"][i.to_s]

        start_worktime = "#{year}-#{month}-#{day} #{start_time}"
        finish_worktime = "#{year}-#{month}-#{day} #{finish_time}"
        start_breaktime = "#{year}-#{month}-#{day} #{start_breaktime}"
        finish_breaktime = "#{year}-#{month}-#{day} #{finish_breaktime}"

        attendance.update(start_worktime: start_worktime, finish_worktime: finish_worktime, start_breaktime: start_breaktime, finish_breaktime: finish_breaktime, comment: t["comment"][i.to_s], reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i])
      else
        Attendance.create(
          worker_id: params[:id],
          start_worktime: DateTime.new(start_time),
          finish_worktime: t["finish_worktime"][i.to_s],
          start_breaktime: t["start_breaktime"][i.to_s],
          finish_breaktime: t["finish_breaktime"][i.to_s],
          comment: t["comment"][i.to_s],
          stamp_date: params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, i) : Date.new(Date.current.year, Date.current.month, i),
          reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i]
        )
      end
    end
      flash[:notice] = "You have updated attendance successfully."
      redirect_to workers_attendance_path(params[:id])
  end


  def start
    @attendance = current_worker.attendances.new
    @attendance.stamp_date = Date.current
    @attendance.start_worktime = Time.zone.now
    if @attendance.save
      redirect_to workers_homes_top_path
    else
      redirect_to workers_homes_top_path
    end
  end


  def finish
    @attendance = current_worker.attendances.where.not(start_worktime: nil).where(finish_worktime: nil).first
    if @attendance.present?
      @attendance.finish_worktime = Time.zone.now
      @attendance.save
      redirect_to workers_homes_top_path
    else
      redirect_to workers_homes_top_path
    end
  end


  def start_breaktime
    @attendance = current_worker.attendances.new
    @attendance.start_breaktime = Time.zone.now
    if @attendance.save
      redirect_to workers_homes_top_path
    else
      redirect_to workers_homes_top_path
    end
  end


  def finish_breaktime
    @attendance = current_worker.attendances.where.not(start_breaktime: nil).where(finish_breaktime: nil).first
    if @attendance.present?
      @attendance.finish_breaktime = Time.zone.now
      @attendance.save
      redirect_to workers_homes_top_path
    else
      redirect_to workers_homes_top_path
    end
  end


  def attendance_status
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    # if #当日の出勤の打刻がある場合、[出勤]打刻時間を表示

    # elsif #当日の退勤の打刻がある場合、[退勤]打刻時間を表示

    # else #両方ない場合、[未打刻]と表示

    # end
  end



private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end
