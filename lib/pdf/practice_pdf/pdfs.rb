module PracticePdf
  class Pdfs < Prawn::Document
    def initialize
      super(page_size: 'A4') # 新規PDF作成
      stroke_axis # 座標を表示

      header
    end

    def header
      font FONT
      text_box 'ヘッダー'

      font FONT_BOLD
      text_box 'ヘッダー', at: [0, 730], size: 10

      font FONT_EXTRALIGHT
      text_box 'ヘッダー', at: [0, 700], size: 20

      font FONT_HEAVY
      text_box 'ヘッダー', at: [0, 650], size: 30

      font FONT_LIGHT
      text_box 'ヘッダー', at: [0, 600], size: 40

      font FONT_MEDIUM
      text_box 'ヘッダー', at: [0, 550], size: 50

      font FONT_NORMAL
      text_box 'ヘッダー', at: [0, 500], size: 60
    end
  end
end