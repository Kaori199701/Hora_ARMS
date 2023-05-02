class Admins::WorkersController < ApplicationController
  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    @worker.save
  end

  def index
  end

  def show
  end

  def edit
  end

private

  def worker_params
    params.require(:worker).permit(:employee_number, :department_id, :director_id, :location_id, :working_hour_id, :last_name, :first_name, :last_name_kana, :sex, :birthday, :first_name_kana, :email, :encryted_password, :hire_date, :retirement_date, :start_career_break, :finish_career_break, :employment_status, :created_at, :updated_at)
  end

end

