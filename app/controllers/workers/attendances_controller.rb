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
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update!(attendance_params)
       flash[:notice] = "You have updated attendance successfully."
       redirect_to workers_attendance_path(@attendance.id)
    else
      render 'edit'
    end
  end

  def start
    @attendance = current_worker.attendances.new
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


private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status)
  end

end
