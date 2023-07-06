class Admins::WorkersController < ApplicationController
  before_action :authenticate_admin!

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      flash[:notice] = "従業員情報を追加しました"
      redirect_to admins_homes_top_path
    else
      # 保存失敗時の処理
      render 'new'
    end
  end


  def index
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
  end


  def edit
    @worker = Worker.find(params[:id])
  end


  def password
    @worker = Worker.find(params[:id])
  end


  def update
    @worker = Worker.find(params[:id])
    if @worker.update(worker_params)
       flash[:notice] = "更新しました。"
       redirect_to admins_worker_path(@worker.id)
    else
      flash[:notice] = "更新できませんでした。もう一度入力してください。"
      render 'password'
    end
  end


private

  def worker_params
    params.require(:worker).permit(:employee_number, :department_id, :director_id, :location_id, :working_hour_id, :last_name, :first_name, :last_name_kana, :sex, :birthday, :first_name_kana, :email, :encryted_password, :hire_date, :retirement_date, :start_career_break, :finish_career_break, :employment_status, :password, :password_confirmation, :created_at, :updated_at)
  end

end
