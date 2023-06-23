class Admins::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model, @content, @method)
  end

  private
  def search_for(model, content, method)
    if model == 'worker'
      if method == 'perfect'
        Worker.where(last_name: content)
      else
        Worker.where('last_name LIKE ?', '%'+content+'%')
      end
    elsif department == 'post'
      if method == 'perfect'
        Department.where(department: content)
      else
        Department.where('department_name LIKE ?', '%'+content+'%')
      end
    end
  end

end
