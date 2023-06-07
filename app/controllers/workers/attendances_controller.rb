class Workers::AttendancesController < ApplicationController
  def index
    @worker = current_worker

    if params[:department_id].present?
      @workers = Worker.where(department_id: params[:department_id])
    elsif params[:name].present?
      @workers = Worker.search(params[:name])
    else
      @workers = Worker.all
    end

    @departments = Department.all
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
    @attendance = Attendance.find(params[:id])
    @worker = @attendance.worker
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
        start_time = t["start_worktime"][i.to_s] || nil
        finish_time = t["finish_worktime"][i.to_s] || nil
        start_breaktime = t["start_breaktime"][i.to_s] || nil
        finish_breaktime = t["finish_breaktime"][i.to_s] || nil

        start_worktime = start_time.present? ? "#{year}-#{month}-#{day} #{start_time}" : nil
        finish_worktime = finish_time.present? ? "#{year}-#{month}-#{day} #{finish_time}" : nil
        start_breaktime = start_breaktime.present? ? "#{year}-#{month}-#{day} #{start_breaktime}" : nil
        finish_breaktime = finish_breaktime.present? ? "#{year}-#{month}-#{day} #{finish_breaktime}" : nil

        attendance.update(start_worktime: start_worktime, finish_worktime: finish_worktime, start_breaktime: start_breaktime, finish_breaktime: finish_breaktime, comment: t["comment"][i.to_s], reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i])
      else
        Attendance.create(
          worker_id: params[:id],
          start_worktime: start_time.present? ? DateTime.new(start_time) : nil,
          finish_worktime: t["finish_worktime"][i.to_s] || nil,
          start_breaktime: t["start_breaktime"][i.to_s] || nil,
          finish_breaktime: t["finish_breaktime"][i.to_s] || nil,
          comment: t["comment"][i.to_s] || nil,
          stamp_date: params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, i) : Date.new(Date.current.year, Date.current.month, i),
          reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i]
        )
      end
    end
      flash[:notice] = "タイムカード編集に成功しました"
      redirect_to workers_attendance_path(params[:id])
  end


  def start
    attendance = current_worker.attendances.new
    attendance.stamp_date = Date.current
    attendance.start_worktime = Time.zone.now
    target_attendance = current_worker.attendances.where(stamp_date:Date.current)
    if (target_attendance.empty? || target_attendance.last.start_worktime.nil?) && attendance.save
      flash[:notice] = "出勤の打刻に成功しました。"
    else
      flash[:notice] = "今日は出勤済みです。"
    end
    redirect_to workers_homes_top_path
  end


  def finish
    attendance = current_worker.attendances.where(finish_worktime:nil).last
    if attendance.present?
      attendance.finish_worktime = Time.zone.now
      attendance.save
      flash[:notice] = "退勤の打刻に成功しました。"
      redirect_to workers_homes_top_path
    else
      flash[:notice] = "今日は退勤済みです。"
      redirect_to workers_homes_top_path
    end
  end


  def start_breaktime
    attendance = current_worker.attendances.where(start_breaktime:nil).last
    if attendance.present?
      attendance.start_breaktime = Time.zone.now
      attendance.save
      flash[:notice] = "休憩開始の打刻に成功しました。"
      redirect_to workers_homes_top_path
    else
      flash[:notice] = "今日は休憩開始済みです。"
      redirect_to workers_homes_top_path
    end
  end


  def finish_breaktime
    attendance = current_worker.attendances.where(finish_breaktime:nil).last
    if attendance.present?
      attendance.finish_breaktime = Time.zone.now
      attendance.save
      flash[:notice] = "休憩終了の打刻に成功しました。"
      redirect_to workers_homes_top_path
    else
      flash[:notice] = "今日は休憩終了済みです。"
      redirect_to workers_homes_top_path
    end
  end


  def attendance_status
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour
  end



private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end
