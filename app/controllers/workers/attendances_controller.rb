class Workers::AttendancesController < ApplicationController
  def index
    @workers = Worker.all
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def edit
    @worker = Worker.find(params[:id])
  end

  def update
    @worker = Worker.find(params[:id])
    if @worker.update!(worker_params)
       flash[:notice] = "You have updateed worker successfully."
       redirect_to admins_worker_path(@worker.id)
    else
      render 'edit'
    end
  end


end
