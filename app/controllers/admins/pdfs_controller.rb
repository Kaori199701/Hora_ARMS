class Admins::PdfsController < ApplicationController
  before_action :authenticate_admin!

  def index
    respond_to do |format|
      format.pdf do
        show_pdf = ShowPdf.new().render
        send_data show_pdf,
          filename: "ファイル名.pdf",
          type: 'application/pdf',
          disposition: 'inline' # 外すとアクセス時に自動ダウンロードされるようになる
      end
    end
  end
end
