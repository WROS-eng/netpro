require "./base_board.rb"

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
end
