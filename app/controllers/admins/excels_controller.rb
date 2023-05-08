class Admins::ExcelsController < ApplicationController
  def index
    # Excelに出力したいデータをインスタンス変数に格納する
    @excels = Attendance.all

    # 以下、追記
    respond_to do |format|
      format.html
      format.xlsx do
        # ファイル名をここで指定する（動的にファイル名を変更できる）
        response.headers['Content-Disposition'] = "attachment; filename=#{Date.today}.xlsx"
      end
    end
  end
end
