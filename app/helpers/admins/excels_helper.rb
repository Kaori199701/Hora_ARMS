module Admins::ExcelsHelper


  #遅刻
  def behind_time(start_working_hour, attendance_start_worktime)
    hour1 = start_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    if attendance_start_worktime
      hour2 = attendance_start_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    end
    minute1 = start_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    if attendance_start_worktime
      minute2 = attendance_start_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    end

    if attendance_start_worktime
      if hour2 >= hour1 && minute2 > minute1    #8:55 8:56
         hour3 = hour2 - hour1
         minute3 = minute2 - minute1
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      elsif hour2 > hour1 && minute2 <= minute1 #8:59 9:00
         hour3 = hour2 - hour1 - 1
         minute3 = 60 + (minute2 - minute1)
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      end
    end
  end

  #早退
  def leave_early(finish_working_hour, attendance_finish_worktime)
    hour1 = finish_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    if attendance_finish_worktime
      hour2 = attendance_finish_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    end
    minute1 = finish_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    if attendance_finish_worktime
      minute2 = attendance_finish_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    end

    if attendance_finish_worktime
      if hour1 >= hour2 && minute1 > minute2    #17:30 17:05
         hour3 = hour1 - hour2
         minute3 = minute1 - minute2
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      elsif hour1 > hour2 && minute1 <= minute2 #17:30 16:50
         hour3 = hour1 - hour2
         minute3 = 60 - (minute2 - minute1)
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      end
    end
  end

  #残業
  def overtime(finish_working_hour, attendance_finish_worktime)
    hour1 = finish_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    if attendance_finish_worktime
      hour2 = attendance_finish_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[0].to_i
    end
    minute1 = finish_working_hour.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    if attendance_finish_worktime
      minute2 = attendance_finish_worktime.to_s.match(/\d{2}:\d{2}/)[0].split(":")[1].to_i
    end

    if attendance_finish_worktime
      if hour1 < hour2 && minute1 >= minute2    #17:30 18:06
         hour3 = hour2 - hour1 - 1
         minute3 = 60 - (minute1 - minute2)
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      elsif hour1 <= hour2 && minute1 < minute2 #17:30 17:50
         hour3 = hour2 - hour1
         minute3 = minute2 - minute1
         formatted_time = "%02d:%02d" % [hour3, minute3]
        "#{formatted_time}"
      end
    end
  end

end
