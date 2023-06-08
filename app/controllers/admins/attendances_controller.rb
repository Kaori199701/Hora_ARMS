class Admins::AttendancesController < ApplicationController
  def show
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def edit
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

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

      if t["id"][i.to_s].present? #打刻時間のidがある場合
        attendance = Attendance.find(t["id"][i.to_s])
        start_time = t["start_worktime"][i.to_s]
        finish_time = t["finish_worktime"][i.to_s]
        start_breaktime = t["start_breaktime"][i.to_s]
        finish_breaktime = t["finish_breaktime"][i.to_s]

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
          #edit_status: Attendance.edit_statuses.keys[t["editn_status"][i.to_s].to_i]
        )
      end
    end
      flash[:notice] = "タイムカード編集に成功しました"
      redirect_to workers_attendance_path(params[:id])
  end



private

  def department_params
    params.require(:department).permit(:department_code, :department_name)
  end

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end
