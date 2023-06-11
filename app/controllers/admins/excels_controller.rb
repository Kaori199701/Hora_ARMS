class Admins::ExcelsController < ApplicationController
  def index
    # workbook = RubyXL::Workbook.new
    # workbook.write("path/to/desired/Excel/file.xlsx")
    @workers = Worker.all
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{Date.today}勤怠情報.xlsx"
      end
    end
  end
end
