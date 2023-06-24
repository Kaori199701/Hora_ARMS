class Admins::ExcelsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @workers = Worker.all
    @attendances = Attendance.all

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{@today.year}年#{@today.mon}月勤怠情報.xlsx"
      end
    end
  end

private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

  def convert_to_japanese_weekday(wday)
    weekdays = %w[(日) (月) (火) (水) (木) (金) (土)]
    weekdays[wday]
  end

end

