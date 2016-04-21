# -*- coding: utf-8 -*-
#
# 定数 WHITELIST は、外部から来るファイル名として許可される文字です。
# sanitize メソッドでは、使用不可の文字を _ (アンダーバー) に変換します。
#
# attahment_fu.rb の sanitize_filename メソッド内で使われています。
#
# 文字コードの調べ方は、 Emacs であれば文字上で C-x = です。
# もしくは http://0xcc.net/jsescape/ で調べます。
# 
# Unicode のブロックについては下記ページを参照して下さい。
# - http://www.unicode.org/Public/UNIDATA/Blocks.txt
# - http://www.moreslowly.jp/bm/?id=2e24251c80d0d644bcc63ce096b57d70e592ed9b
# 

module UnicodeSanitizer
  module_function

  def character(code)
    "#{[code].pack('U')}" 
  end
  
  def range(s, e)
    "#{character(s)}-#{character(e)}"
  end

  WHITELIST =
    [
     'A-Za-z0-9',              # 半角英数字
     '!#%&=~@',                # 記号
     ' ',                      # 半角空白文字
     '\.\-\[\]\(\)\{\}\$\^\+', # 正規表現で使われるものはエスケープします。
     range(0x4E00, 0x9FCF),    # 漢字
     range(0x3040, 0x309F),    # ひらがな
     range(0x30A0, 0x30FF),    # カタカナ
     range(0xFF21, 0xFF3A),    # 全角ローマ字(大)
     range(0xFF41, 0xFF5A),    # 全角ローマ字(小)
     range(0xFF10, 0xFF19),    # 全角数字
     character(0xFF06),        # & アンパサンド
     character(0xFF0E),        # . ピリオド
     character(0xFF0C),        # , コンマ
     character(0x2019),        # ' アポストロフィー
     character(0x201D),        # ”
     character(0xFF0D),        # - ハイフン
     character(0xFF06),        # 中点
     character(0x3000),        # 全角空白
     character(0x3001),        # 、
     character(0x3002),        # 。
     character(0x301C),        # 〜
     character(0xFF0F),        # ／
    ]

  BLACKLIST = Regexp.new('[^' + WHITELIST.inject(:+) + ']')

  def sanitize(str)
    str.gsub(BLACKLIST, '_')
  end
end
