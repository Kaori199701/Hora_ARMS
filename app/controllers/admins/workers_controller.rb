class Admins::WorkersController < ApplicationController
  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    @worker.save
    redirect_to admins_homes_top_path
  end

  def index
    if params[:department_id].present?
      @workers = Worker.where(department_id: params[:department_id])
    else
      @workers = Worker.all
    end

    @departments = Department.all

    #もしWorkerの名前を検索していたら名前が合致した人だけ表示

    #もしdepartmentの名称を選択したら所属が合致した人だけ表示
    #もし何も選択していなかったら全員表示
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def edit
    @worker = Worker.find(params[:id])
  end

  def password
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


private

  def worker_params
    params.require(:worker).permit(:employee_number, :department_id, :director_id, :location_id, :working_hour_id, :last_name, :first_name, :last_name_kana, :sex, :birthday, :first_name_kana, :email, :encryted_password, :hire_date, :retirement_date, :start_career_break, :finish_career_break, :employment_status, :password, :password_confirmation, :created_at, :updated_at)
  end

end

