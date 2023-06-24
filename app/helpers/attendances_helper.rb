module AttendancesHelper
  def behind_time(start_working_hour, attendance_start_worktime)
#   # start_working_hour - attendance_start_worktime
    hour1 = start_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    if attendance_start_worktime
      hour2 = attendance_start_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    end
    minute1 = start_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    if attendance_start_worktime
      minute2 = attendance_start_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    end

#17:59 18:00
#17:55 17:56 hour2 > hour1 || minute2 > minute1

    if attendance_start_worktime
      if hour2 >= hour1 && minute2 > minute1
        "#{hour2 - hour1}:#{minute2 - minute1}"
      elsif
        hour2 > hour1 && minute2 <= minute1
        "#{hour2 - hour1 - 1}:#{minute2 + minute1 })"
      end
    end
  end
end
