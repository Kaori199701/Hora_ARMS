class Workers::WorkersController < ApplicationController
  before_action :authenticate_worker!

  def show
    @worker = Worker.find(params[:id])
  end

  def password
    @worker = Worker.find(params[:id])
  end

  def update
    @worker = Worker.find(params[:id])
    if @worker.update(worker_params)
      flash[:notice] = "パスワードを更新しました。新しいパスワードで再度ログインしてください。"
      redirect_to new_worker_session_path
    else
      flash[:notice] = "パスワードを更新できませんでした。もう一度入力してください。"
      render 'password'
    end
  end

private

  def worker_params
    params.require(:worker).permit(:password, :password_confirmation)
  end

end
