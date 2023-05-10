class Admins::HomesController < ApplicationController
  def top
    @workers = Worker.all
  end
end
