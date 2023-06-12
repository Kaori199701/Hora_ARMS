class Pdfs < Prawn::Document
  def initialize
    super(page_size: 'A4') #A4サイズのPDFを新規作成
    stroke_axis # 座標を表示
  end
end