class Admins::DepartmentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @department = Department.new
    @departments = Department.all
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to admins_departments_path
    else
      flash[:notice] = "所属情報追加に失敗しました"
      redirect_to admins_departments_path
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update(department_params)
       redirect_to admins_departments_path
    else
      flash[:notice] = "所属情報の保存に失敗しました"
      render 'edit'
    end
  end


private

  def department_params
    params.require(:department).permit(:department_code, :department_name)
  end

end
