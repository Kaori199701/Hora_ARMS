class Admins::HomesController < ApplicationController
  def top
    if params[:department_id].present?
      @workers = Worker.where(department_id: params[:department_id])
    elsif params[:name].present?
      @workers = Worker.search(params[:name])
    else
      @workers = Worker.all
    end

    @departments = Department.all

  end
end