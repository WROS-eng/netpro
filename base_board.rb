# ボードの基底クラス
class BaseBoard

  # 色のマップリスト。とりあえずボードが持ってます
  COLOR = { white: 1, black: -1 }.freeze


  # 盤面の状態マップリスト。
  FIELD = COLOR.merge({blank: 0, wall: 9}).freeze

  # format用絵文字マップリスト
  MARK = { white: "○", black: "●", blank: "0", wall: "■" }.freeze

  # 1辺のマス数(端1 + マス8 + 端1)
  SQUARES = 10.freeze
  
  #置いた位置からの向き
  DIR = {up_left: -SQUARES, up: -SQUARES + 1, up_right:-SQUARES + 2, left: -1 , center: 0, right: 1, down_left: SQUARES - 2, down: SQUARES - 1, down_right: SQUARES}.freeze

  # コンストラクタ
  def initialize
    reset
  end

  # 盤面情報の初期化
  def reset
    @field = Array.new(SQUARES*SQUARES, FIELD[:wall])
    (1..8).each{|x| (1..8).each{|y| set_square(x, y, FIELD[:blank])}}
    set_square(4, 4, COLOR[:white])
    set_square(5, 5, COLOR[:white])
    set_square(4, 5, COLOR[:black])
    set_square(5, 4, COLOR[:black])
  end

  # 座標からマス情報を取得。
  # x : 横
  # y : 縦
  def get_square(x, y)
    index = x + y * SQUARES
    @field[index]
  end

  # 座標のマス情報を変更。
  # x : 横
  # y : 縦
  def set_square(x, y, color)
    index = x + y * SQUARES
    @field[index] = color
  end

  # デバッグ用表示関数
  def debug_print
    require 'pp'
    pp @field.each_slice(10).to_a
  end
end

