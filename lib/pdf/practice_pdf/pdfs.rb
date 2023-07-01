module PracticePdf
  class Pdfs < Prawn::Document

    def initialize(worker,attendances,current_month,today)
      super(page_size: 'A4') # 新規PDF作成


      @worker = worker
      @attendances = attendances
      @current_month = current_month
      @today = today

      font 'app/assets/fonts/SourceHanSans-Regular.ttc'
      header
      contents
    end

    def header
      text "#{@today.mon}月勤務個人表", size: 20, align: :center

      text "作成日: #{Date.today}",align: :right, size: 10

      text "#{@today.year}年#{@today.mon}月",align: :left, size: 10
      text "所属: #{@worker.department.department_code} #{@worker.department.department_name}",align: :left, size: 10
      text "役職: #{@worker.director.director_code} #{@worker.director.director_name}",align: :left, size: 10
      text "従業員名: #{@worker.employee_number} #{@worker.full_name}",align: :left, size: 10
    end

    def contents
      move_down 20

      rows = []
      rows[0] = ['月日','曜日','勤務区分','事由','出勤','退勤','休憩開始','休憩終了','遅刻','早退','残業']

      i = 1
      @current_month.count.times do

          if @worker.attendances.exists?(stamp_date: Time.new(@today.year, @today.mon, i))
            attendance = @worker.attendances.find_by(stamp_date: Time.new(@today.year, @today.mon, i).beginning_of_day..Time.new(@today.year, @today.mon, i).end_of_day)
      rows[i] = [attendance.stamp_date&.strftime('%m/%d').to_s,
                 @current_month[i-1][:weekday_jp],
                 "#{@worker.working_hour.start_working_hour&.strftime('%H:%M')}",
                 attendance.reason_status_i18n, attendance.start_worktime&.strftime('%H:%M').to_s,attendance.finish_worktime&.strftime('%H:%M').to_s,
                 attendance.start_breaktime&.strftime('%H:%M').to_s,attendance.finish_breaktime&.strftime('%H:%M').to_s,
                 ApplicationController.helpers.behind_time(@worker.working_hour.start_working_hour, attendance.start_worktime),
                 ApplicationController.helpers.leave_early(@worker.working_hour.finish_working_hour, attendance.finish_worktime),
                 ApplicationController.helpers.overtime(@worker.working_hour.finish_working_hour, attendance.finish_worktime)]

          else

          rows[i] = [Time.new(@today.year, @today.mon, i)&.strftime('%m/%d').to_s, @current_month[i-1][:weekday_jp],'', '','','','','','','','']
          end

      i += 1
    end

      #テーブルの作成。カラムが11つ。それぞれの幅を指定。
      table(rows, column_widths: [40, 30, 50, 35, 50, 50, 50, 50, 50, 50, 50], position: :center) do |table|
      table.cells.size = 10
      table.row(0).align = :center
      end


      # move_down 10

      # rows = [['規定','勤務','公休','欠勤','休日出勤','特休','有休'],
      # ["23.0", '22.0',"8", "","","","1.0"]
      # ]
      # #テーブルの作成。カラムが４つ。それぞれの幅を指定。
      # table(rows, column_widths: [50, 50, 50, 50, 50, 50, 50], position: :center) do |table|
      # table.cells.size = 10
      # table.row(0).align = :center
      # end

    end

  end
end