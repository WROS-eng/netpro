# ボードの基底クラス
class BaseBoard

  # 色のマップリスト。とりあえずボードが持ってます
  COLOR = { white: 1, black: -1 }.freeze

  # 盤面の状態マップリスト。
  FIELD = COLOR.merge({blank: 0, wall: 9}).freeze

  # format用絵文字マップリスト
  MARK = { white: " ○", black: " ●", blank: " 0", wall: " ■" }.freeze

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
    # 盤面情報は1次元配列で管理
    @field = Array.new(SQUARES*SQUARES, FIELD[:wall])
    (1..8).each{|x| (1..8).each{|y| set_square(x, y, FIELD[:blank])}}
    set_square(4, 4, COLOR[:white])
    set_square(5, 5, COLOR[:white])
    set_square(4, 5, COLOR[:black])
    set_square(5, 4, COLOR[:black])
  end

  # 指定indexのマス情報を取得。
  # index : 要素index
  def get_square_by_index(index)
    @field[index]
  end

  # 指定indexのマス情報を変更。
  # index : 要素index
  # color : 変更する色
  def set_square_by_index(index, color)
    @field[index] = color
  end

  # 座標からマス情報を取得。
  # x : 横
  # y : 縦
  def get_square(x, y)
    get_square_by_index(xy2index(x, y))
  end

  # 座標のマス情報を変更。
  # x : 横
  # y : 縦
  # color : 変更する色
  def set_square(x, y, color)
    set_square_by_index(xy2index(x, y), color)
  end

  # xy座標をindexに変換
  # x : 横
  # y : 縦
  def xy2index(x, y)
    x + y * SQUARES
  end

  # indexをxy座標に変換
  # index : 要素index
  def index2xy(index)
    x, y = index%SQUARES, index/SQUARES
  end

  # デバッグ用表示関数
  def debug_print
    require 'pp'
    pp @field.each_slice(10).to_a
  end
end

