
# 盤面情報を格納するクラス
class Board

  # 色のマップリスト。とりあえずボードが持ってます
  COLOR = { white: 1, black: -1 }.freeze

  # 盤面の状態マップリスト。
  FIELD = COLOR.merge({none: 0}).freeze

  # format用絵文字マップリスト
  MARK = { white: "●", black: "○", none: "□" }.freeze

  # 1辺のマス数
  SQUARES = 8.freeze

  def initialize
    reset
  end

  # 盤面情報の初期化
  def reset
    @field = Array.new(SQUARES){Array.new(SQUARES,0)}
    @field[3][3], @field[4][4] = COLOR[:white], COLOR[:white]
    @field[4][3], @field[3][4] = COLOR[:black], COLOR[:black]
  end

  # 記号文字で出力
  def pretty_print
    puts "  #{(1..SQUARES).to_a.join(' ')}"   # 列番号
    @field.each_with_index do |line, i|
      print "#{i+1} "                         # 行番号
      puts line                               # 2次元配列の要素 => [0, 0, 1, -1, ...]
        .map{|l| FIELD.key(l)}                # 値に対応するキーを取得 => [:none, :none, :white, :black]
        .map{|k| MARK[k]}                     # キーから出力文字取得 => ["□", "□", "○", "●"]
        .join(' ')                            # 文字列に連結 => "□ □ ○ ●"
    end
  end
end