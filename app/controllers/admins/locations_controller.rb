class Admins::LocationsController < ApplicationController

  def index
    @location = Location.new
    @locations = Location.all
  end

  def create
    @location = Location.new(location_params)
    @location.save
    redirect_to admins_locations_path
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(location_params)
       flash[:notice] = "You have created location successfully."
       redirect_to admins_locations_path
    else
      render 'locations/edit'
    end
  end


private

  def location_params
    params.require(:location).permit(:start_worktime, :location_name)
  end

end
