# require 'practice_pdf/pdfs'
class Admins::PdfsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @workers = Worker.all

    @worker = Worker.find(1)
    @attendances = Attendance.where(worker: @worker)


    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end


  end

  def pdf_show #pdfを作る
    @worker = Worker.find(1)
    @attendances = Attendance.where(worker: @worker)

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end


    respond_to do |format|
      format.html
      format.pdf do
        admins_pdf = PracticePdf::Pdfs.new(@worker,@attendances,@current_month,@today).render  #lib/pdf/practice_pdf/pdfs.rbを呼び出す
          send_data admins_pdf,
          filename: "ファイル名.pdf",
          type: 'application/pdf',
          disposition: 'inline' # 外すとアクセス時に自動ダウンロードされるようになる
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
