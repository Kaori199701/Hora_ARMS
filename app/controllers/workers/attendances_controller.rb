class Workers::AttendancesController < ApplicationController
  before_action :authenticate_worker!


  def index
    @worker = current_worker

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
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current
    @attendances = @attendances.where(stamp_date: @today.beginning_of_month..@today.end_of_month)

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }

    @current_month = @current_month.map do |day|
      { date: day, weekday_jp: convert_to_japanese_weekday(day.wday) }
    end
  end


  def edit
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    @years = (Date.current.year - 5..Date.current.year + 1).to_a.reverse
    @today = params[:month].present? ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
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
          reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i],
          stamp_date: Date.new(year, month, i),
          edit_status: Attendance.edit_statuses["worker_edited"]
      }
      # 保存
      attendance.save!
    end
    flash[:notice] = "タイムカード編集に成功しました"
    redirect_to workers_attendance_path(params[:id])
  end


  def start
    attendance = current_worker.attendances.new
    attendance.stamp_date = Date.current
    attendance.start_worktime = Time.zone.now
    target_attendance = current_worker.attendances.where(stamp_date:Date.current)
    if (target_attendance.empty? || target_attendance.last.start_worktime.nil?) && attendance.save
      flash[:notice] = "出勤の打刻に成功しました。"
    else
      flash[:notice] = "今日は出勤済みです。"
    end
    redirect_to workers_homes_top_path
  end


  def finish
    attendance = current_worker.attendances.where(finish_worktime:nil).where(stamp_date: Date.current).last
    if attendance.present?
      attendance.finish_worktime = Time.zone.now
      attendance.save
      flash[:notice] = "退勤の打刻に成功しました。"
    else
      flash[:notice] = "今日は退勤済みです。"
    end
    redirect_to workers_homes_top_path
  end


  def start_breaktime
    attendance = current_worker.attendances.where(start_breaktime:nil).where(stamp_date: Date.current).last
    if attendance.present?
      attendance.start_breaktime = Time.zone.now
      attendance.save
      flash[:notice] = "休憩開始の打刻に成功しました。"
    else
      flash[:notice] = "今日は休憩開始済みです。"
    end
    redirect_to workers_homes_top_path
  end


  def finish_breaktime
    attendance = current_worker.attendances.where(finish_breaktime:nil).where(stamp_date: Date.current).last
    if attendance.present?
      attendance.finish_breaktime = Time.zone.now
      attendance.save
      flash[:notice] = "休憩終了の打刻に成功しました。"
    else
      flash[:notice] = "今日は休憩終了済みです。"
    end
    redirect_to workers_homes_top_path
  end


  def attendance_status
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour
  end


  def destroy
    attendance = Attendance.find_by(worker_id: current_worker.id, stamp_date: params[:date] )
    attendance.destroy
    redirect_back(fallback_location: root_path)
  end



private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date, :edit_status, :updated)
  end

  def convert_to_japanese_weekday(wday)
    weekdays = %w[(日) (月) (火) (水) (木) (金) (土)]
    weekdays[wday]
  end

  # def update_attendance_params
  #   t = params["worker"]
  # end

end
