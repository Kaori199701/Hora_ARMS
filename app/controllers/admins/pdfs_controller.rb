# require 'practice_pdf/pdfs'
class Admins::PdfsController < ApplicationController
  before_action :authenticate_admin!

  def index

  end

  def pdf_show #pdfを作る

     respond_to do |format|
      format.html
      format.pdf do
        admins_pdf = PracticePdf::Pdfs.new().render  #lib/pdf/practice_pdf/pdfs.rbを呼び出す
          send_data admins_pdf,
          filename: "ファイル名.pdf",
          type: 'application/pdf',
          disposition: 'inline' # 外すとアクセス時に自動ダウンロードされるようになる
      end
     end

  end
end
