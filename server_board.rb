require './base_board.rb'

# 盤面情報を格納するクラス
class ServerBoard < BaseBoard

  # コマを置く
  # x : 横
  # y : 縦
  # color : コマの色
  # return field_diff : クライアントに反映する石のリスト
  def put(x, y, color)
    field_diff = get_flip_list(color, x, y) + [xy2index(x, y)]
    update(field_diff, color)
    return field_diff
  end

  # 置けるマスがあるか
  # 空きマスに対して全探索で置いた際にひっくり返せる場所があるか確認する
  def put_place_exist?(color)
    (0..@field.length)
      .select { |i| get_square_by_index(i) == FIELD[:blank] }
      .map { |i| index2xy(i) }
      .any? { |f| get_flip_count(color, f[0], f[1]) > 0 }
  end

end
