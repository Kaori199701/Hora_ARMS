class Admins::ExcelsController < ApplicationController
  def index
    # workbook = RubyXL::Workbook.new
    # workbook.write("path/to/desired/Excel/file.xlsx")
    @workers = Worker.all
    @attendances = Attendance.all

    @today = Date.current

    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{Date.today}勤怠情報.xlsx"
      end
    end
  end
end
