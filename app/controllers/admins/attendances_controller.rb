class Admins::AttendancesController < ApplicationController
  before_action :authenticate_admin!

  def show
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    # 当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end
  end


  def edit
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    # 当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end
  end


  def update
    # 選択された月をとってくる
    @today = Date.new(params[:worker][:year].to_i, params[:worker][:month].to_i, 1)
    number_of_month = @today.end_of_month.day
    t = params["worker"]

    year =  @today.year
    month = @today.month

    number_of_month.times do |i|
      i += 1
      day = i.to_s
      fomart_date = "#{year}-#{month}-#{day}"

      # すべて空であれば次の日に進む
      if t["start_worktime"][day].blank? &&
        t["finish_worktime"][day].blank? &&
        t['start_breaktime'][day].blank? &&
        t['finish_breaktime'][day].blank? &&
        t["comment"][i.to_s].blank? &&
        (t["reason_status"][i.to_s].to_i == 0 )
        next
      end

      # 勤務開始/終了時間/休憩時間をそれぞれ取得して、なければnilにする。
      # 2023-06-01 10:10.000
      start_worktime = t['start_worktime'][day].present? ? DateTime.parse("#{fomart_date} #{t['start_worktime'][day]} JST") : nil
      finish_worktime = t['finish_worktime'][day].present? ? DateTime.parse("#{fomart_date} #{t['finish_worktime'][day]} JST") : nil
      start_breaktime = t['start_breaktime'][day].present? ? DateTime.parse("#{fomart_date} #{t['start_breaktime'][day]} JST") : nil
      finish_breaktime = t['finish_breaktime'][day].present? ? DateTime.parse("#{fomart_date} #{t['finish_breaktime'][day]} JST") : nil

      # 既にレコードが存在していて編集するのか新規に追加するのか
      attendance = Attendance.find_or_initialize_by(id: t["id"][i.to_s])
      next unless t["updated"][day].to_i == 1

      # フォームから送られてきたデータを取得
      attendance.attributes = {
          worker_id: params[:id],
          start_worktime: start_worktime,
          finish_worktime: finish_worktime,
          start_breaktime: start_breaktime,
          finish_breaktime: finish_breaktime,
          comment: t["comment"][i.to_s],
          reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i], #ここおかしい？
          stamp_date: Date.new(year, month, i),
          edit_status: Attendance.edit_statuses["admin_edited"]
      }
      # 保存
      attendance.save!
    end
    flash[:notice] = "タイムカードを更新しました"
    redirect_to admins_attendance_path(params[:id])
  end


  def destroy
    @worker = Worker.find(params[:id])
    attendance = Attendance.find_by(worker_id: @worker.id, stamp_date: params[:date] )
    attendance.destroy
    redirect_back(fallback_location: root_path)
  end


private

  def department_params
    params.require(:department).permit(:department_code, :department_name)
  end

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

  def convert_to_japanese_weekday(wday)
    weekdays = %w[(日) (月) (火) (水) (木) (金) (土)]
    weekdays[wday]
  end

end
