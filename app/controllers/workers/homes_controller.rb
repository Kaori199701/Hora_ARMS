class Workers::HomesController < ApplicationController
  def top
    @attendance = Attendance.new
    @worker = current_worker
    @informations = Attendance.all


    if params[:start_worktime].nil? # :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime に値がないとき
      @infomations = Attendance.where(id: params[:start_worktime]) #打刻がない日付を探す
      #●月●日に打刻漏れがあります。(1か月単位？)
    else  #上4つに値がある場合
      #何も表示しない
    end


  end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.save
    redirect_to workers_attendances_path
  end


private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end