class Admins::ExcelsController < ApplicationController
  def index
    @workers = Worker.all
    respond_to do |format|
      format.html { pagination(@workers) }
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="workers.xlsx"'
      end
    end
  end
end
