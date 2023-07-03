class Admins::WorkingHoursController < ApplicationController
  before_action :authenticate_admin!

  def index
    @working_hour = WorkingHour.new
    @working_hours = WorkingHour.all
  end

  def create
    @working_hour = WorkingHour.new(working_hour_params)
    if @working_hour.save
      redirect_to admins_working_hours_path
    else
      flash[:notice] = "勤務区分情報追加に失敗しました"
      redirect_to admins_working_hours_path
    end
  end

  def edit
    @working_hour = WorkingHour.find(params[:id])
  end

  def update
    @working_hour = WorkingHour.find(params[:id])
    if @working_hour.update(working_hour_params)
       flash[:notice] = "You have created working_hour successfully."
       redirect_to admins_working_hours_path
    else
      render 'working_hours/edit'
    end
  end


private

  def working_hour_params
    params.require(:working_hour).permit(:working_hour_code, :start_working_hour, :finish_working_hour)
  end

end
