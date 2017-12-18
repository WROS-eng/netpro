require "./base_board.rb"

# 盤面情報を格納するクラス
class ServerBoard < BaseBoard

  # その場所に置くことが出来るか。
  # x : 横
  # y : 縦
  # color : コマの色
  # return is_none : 空きマス(none)か
  def can_put?(x, y, color)
    get_square(x, y) == FIELD[:none]
  end

  # ひっくり返せるか
  # x : 横
  # y : 縦
  # color : コマの色
  # return can_reverse : 周りにコマがあり、ひっくり返すことが出来る
  def can_reverse?(x, y, color)
    # チェック方向
    #         上     右上      右      右下      下       左下       左       左上
    step = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    # reverse_list = []
    # step.each do |s|
    #   cx, cy = x, y
    #   loop do
    #     list = []
    #     cx += s[0]; cy += s[1]
    #     break if cx >= 0 && cy >= 0 && cx < SQUARES && cy < SQUARES
    #     square = get_square(cx, cy)
    #     if square == COLOR[:none]
    #   end
    # end
  end

  # コマを置く
  def put(x, y, color)

  end

  # ひっくり返す
  #
  def reverse()

  end

  # 記号文字で出力
  # 改行コード入り文字列で渡すので受取側でputsして下さい
  def pretty_print
    header = "  #{(1..SQUARES).to_a.join(' ')}\n"   # 列番号
    body = ""
    @field.each_with_index do |line, i|
      body += "#{i+1} "                             # 行番号
      body += line                                  # 2次元配列の要素 => [0, 0, 1, -1, ...]
        .map{|l| FIELD.key(l)}                      # 値に対応するキーを取得 => [:none, :none, :white, :black]
        .map{|k| MARK[k]}                           # キーから出力文字取得 => ["□", "□", "○", "●"]
        .join(' ') + "\n"                           # 文字列に連結 => "□ □ ○ ●"
    end
    header + body
  end
end

board = ServerBoard.new
puts board.pretty_print