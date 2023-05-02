class Admins::DepartmentsController < ApplicationController

  def index
    @department = Department.new
    @departments = Department.all
  end

  def create
    @department = Department.new(department_params)
    @department.save
    redirect_to admins_departments_path
  end

  def edit
    @department = Department.find(params[:id])
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
