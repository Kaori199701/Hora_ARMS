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
    @department = Department.find(params[:id])
    if @department.update(department_params)
       flash[:notice] = "You have created department successfully."
       redirect_to admins_departments_path
    else
      render 'departments/edit'
    end
  end


private

  def department_params
    params.require(:department).permit(:department_code, :department_name)
  end

end
