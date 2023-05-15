class Admins::AttendancesController < ApplicationController
  def show
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour
  end

  def edit
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour
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
