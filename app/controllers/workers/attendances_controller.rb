class Workers::AttendancesController < ApplicationController
  def index
    @workers = Worker.all
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def edit
    @worker = Worker.find(params[:id])
  end

  def update
    @worker = Worker.find(params[:id])
    if @worker.update!(worker_params)
       flash[:notice] = "You have updateed worker successfully."
       redirect_to admins_worker_path(@worker.id)
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

end
