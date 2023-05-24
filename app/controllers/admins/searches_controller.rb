class Admins::SearchesController < ApplicationController

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
        Worker.where(name: content)
      else
        Worker.where('name LIKE ?', '%'+content+'%')
      end
    elsif department == 'post'
      if method == 'perfect'
        Department.where(title: content)
      else
        Department.where('title LIKE ?', '%'+content+'%')
      end
    end
  end

end
