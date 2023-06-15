class Admins::AttendancesController < ApplicationController
  def show
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

    @today = params[:month].present? ? Date.new(Date.current.year, params[:month].to_i, 1) : Date.current

    #　当月の日付を取得
    current_month = Array.new(35){ |i| @today.beginning_of_month + ( i - @today.beginning_of_month.wday) }
    @current_month = current_month.filter { |day| @today.mon == day.mon }
  end


  def edit
    @attendance = Attendance.find(params[:id])
    @worker = Worker.find(params[:id])
    @attendances = Attendance.where(worker: @worker)
    @start_working_hour = @worker.working_hour.start_working_hour
    @finish_working_hour = @worker.working_hour.finish_working_hour

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
          reason_status: Attendance.reason_statuses.keys[t["reason_status"][i.to_s].to_i], #ここおかしい？
          stamp_date: Date.new(year, month, i),
          edit_status: Attendance.edit_statuses["admin_edited"]
      }
      # 保存
      attendance.save!
    end
    flash[:notice] = "タイムカード編集に成功しました"
    redirect_to admins_attendance_path(params[:id])
  end



private

  def department_params
    params.require(:department).permit(:department_code, :department_name)
  end

  def attendance_params
    params.require(:attendance).permit(:worker_id, :start_worktime, :finish_worktime, :start_breaktime, :finish_breaktime, :comment, :reason_status, :stamp_date)
  end

end
