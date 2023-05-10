class Workers::HomesController < ApplicationController
  def top
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.save
    redirect_to workers_attendances_path
  end

end
