class Workers::AttendancesController < ApplicationController
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

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current
    @attendances = @attendances.where(stamp_date: @today.beginning_of_month...@today.end_of_month)

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def edit
    @attendance = Attendance.find(params[:id])
    @worker = @attendance.worker
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = current_worker.working_hour.start_working_hour
    @finish_working_hour = current_worker.working_hour.finish_working_hour

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def update
    # 選択された月をとってくる
    @today = Date.new(Date.current.year, params[:worker][:month].to_i, 1)
    number_of_month = @today.end_of_month.day
    t = params["worker"]

    year =  @today.year
    month = @today.month

    number_of_month.times do |i|
      i += 1
      day = i.to_s

      # 勤務開始日時と終了日時が入っていない場合は次の日へ進む
      if t["start_worktime"][day].blank? || t["finish_worktime"][day].blank?
        next
      end

      # 勤務開始日時と終了日時休憩時間をそれぞれ取得する。
      # 2023-06-01 10:10.000
      # 2023-6-1 10:10.000
      # 2023-06-01 10.10.000Z
      start_worktime = DateTime.parse("#{year}-#{month}-#{day} #{t['start_worktime'][day]} JST")
      finish_worktime = DateTime.parse("#{year}-#{month}-#{day} #{t['finish_worktime'][day]} JST")
      if t['start_breaktime'][day].present?
        start_breaktime = DateTime.parse("#{year}-#{month}-#{day} #{t['start_breaktime'][day]} JST")
      end
      if t['finish_breaktime'][day].present?
        finish_breaktime = DateTime.parse("#{year}-#{month}-#{day} #{t['finish_breaktime'][day]} JST")
      end

      # 既にレコードが存在していて編集するのか新規に追加するのか
      if t["id"][day].present?
        updated_flag = t["updated"][day] || nil
        # 更新されたものだけ検知(1じゃなければ次へ)
        if updated_flag != "1" then
          next
        end
        attendance = Attendance.find(t["id"][i.to_s])
      else
        attendance = Attendance.new()
      end

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



private

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date, :edit_status, :updated)
  end

end
