class Admins::DirectorsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @director = Director.new
    @directors = Director.all
  end

  def create
    @director = Director.new(director_params)
    if @director.save
      redirect_to admins_directors_path
    else
      flash[:notice] = "役職情報追加に失敗しました"
      redirect_to admins_directors_path
    end
  end

  def edit
    @director = Director.find(params[:id])
  end

  def update
    @director = Director.find(params[:id])
    if @director.update(director_params)
       flash[:notice] = "You have created director successfully."
       redirect_to admins_directors_path
    else
      render 'directors/edit'
    end
  end


private

  def director_params
    params.require(:director).permit(:director_code, :director_name)
  end

end
