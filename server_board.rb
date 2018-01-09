require "./base_board.rb"

# 盤面情報を格納するクラス
class ServerBoard < BaseBoard

  # コマを置く
  # x : 横
  # y : 縦
  # color : コマの色
  # return stone_indices : ひっくり返した石のリスト
  def put(x, y, color)
    flip_stones = get_flip_list(color, x, y)
    set_square(x, y, color)
    flip(flip_stones, color)
    return flip_stones
  end
end
