# ボードの基底クラス
class BaseBoard

  # 色のマップリスト。とりあえずボードが持ってます
  COLOR = { white: 1, black: -1 , yellow:2}.freeze

  # 盤面の状態マップリスト。
  FIELD = COLOR.merge(blank: 0, wall: 9).freeze

  # format用絵文字マップリスト
  MARK = { white: '⚪️', black: '⚫️',yellow: '😤' , blank: '❇️', wall: '⬛️' }.freeze

  # 1辺のマス数(端1 + マス8 + 端1)
  SQUARES = 16

  # 置いた位置からの向き
  DIR = { up_left: -SQUARES - 1, up: -SQUARES, up_right: -SQUARES + 1, left: -1, center: 0, right: 1, down_left: SQUARES - 1, down: SQUARES , down_right: SQUARES + 1 }.freeze

  # コンストラクタ
  def initialize
    reset
  end

  # 盤面情報の初期化
  def reset
    # 盤面情報は1次元配列で管理
    @field = Array.new(SQUARES * SQUARES, FIELD[:wall])

    (1..SQUARES - 2).each { |x| (1..SQUARES - 2 ).each { |y| set_square(x, y, FIELD[:blank]) } }
    center = (SQUARES - 2) / 2
    center_upper = center + 1
    center2upper = center + 2
    center_lower = center - 1
    center2lower = center - 2

    set_square(center_upper, center_lower, COLOR[:white])
    set_square(center, center, COLOR[:white])
    set_square(center_lower, center_upper, COLOR[:white])

    set_square(center_upper, center_upper, COLOR[:black])
    set_square(center, center_lower, COLOR[:black])
    set_square(center_lower, center, COLOR[:black])

    set_square(center_upper, center, COLOR[:yellow])
    set_square(center, center_upper, COLOR[:yellow])
    set_square(center_lower, center_lower, COLOR[:yellow])
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
    return index % SQUARES, index / SQUARES
  end

  # ひっくり返す
  # stone_indices : ひっくり返す石の座標リスト
  # color : コマの色
  # return ひっくり返した数
  def update(stone_indices, color)
    stone_indices.each { |idx| set_square_by_index(idx, color) }
  end

  # 指定マスに置いた際に反転する石の数を返す
  # x : 置くx座標
  # y : 置くy座標
  # color : 置く石の石の色
  # return 反転する石の数。1以上ならひっくり返すことができる
  def get_flip_count(color, x, y)
    get_flip_list(color, x, y).length
  end

  # 指定マスに置いた際に反転する石リストを返す処理
  # x : 置くx座標
  # y : 置くy座標
  # color : 置く石の石の色
  # return result : 反転する石のindexリスト。リストの長さが1以上ならひっくり返すことができる
  def get_flip_list(color, x, y)
    result = []

    # 一列ずつ見て行く.centerは置いた場所なので、見なくてよい
    result += get_flip_list_with_dir(color, x, y, DIR[:up_left])
    result += get_flip_list_with_dir(color, x, y, DIR[:up])
    result += get_flip_list_with_dir(color, x, y, DIR[:up_right])
    result += get_flip_list_with_dir(color, x, y, DIR[:left])
    result += get_flip_list_with_dir(color, x, y, DIR[:right])
    result += get_flip_list_with_dir(color, x, y, DIR[:down_left])
    result += get_flip_list_with_dir(color, x, y, DIR[:down])
    result += get_flip_list_with_dir(color, x, y, DIR[:down_right])

    return result
  end

  # 指定一方向の反転する石リストを返す処理
  # x : 置くx座標
  # y : 置くy座標
  # color : 置く石の石の色
  # pos_dir : 反転方向
  # return result : 反転する石のindexリスト。
  def get_flip_list_with_dir(color, x, y, flip_dir)
    # 配列のindexで探索するため、xyをindex情報に変換する
    put_pos = xy2index(x, y)

    # 置いた場所からdirの方向に一つずれたところから探索
    pos = put_pos + flip_dir

    flip_list = []
    exclude_put_colors = COLOR.values - [color]
    # 置いたカラー以外の色ならdir方向に探索
    while exclude_put_colors.include?(get_square_by_index(pos))
      flip_list.push(pos)
      pos += flip_dir
    end

    # 探索終了したマスが置いた色と異なる場合はリストを空にする
    flip_list.clear if get_square_by_index(pos) != color

    return flip_list
  end

  # その色の石の数を返す
  def get_stone_cnt(color)
    @field.select{ |f| f == color }.length
  end

  # colorをMarkに変える変数
  def parse_color_to_mark(color)
    return MARK[COLOR.key(color)]
  end
end
