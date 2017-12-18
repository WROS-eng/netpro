require "./base_board.rb"

# 盤面情報を格納するクラス
class ServerBoard < BaseBoard

  # コマを置く
  # x : 横
  # y : 縦
  # color : コマの色
  # return reverse_count : ひっくり返した数
  def put(x, y, color)
    set_square(x, y, color)
    stones = get_reverse_stones(x, y, color)
    reverse_count = reverse(stones)
    return reverse_count
  end

  private
  # ひっくり返す石の座標リストをもらう
  # x : 横
  # y : 縦
  # color : コマの色
  # return ひっくり返す石の座標リスト
  def get_reverse_stones(x, y, color)


  end

  # ひっくり返す
  # stones : ひっくり返す石の座標リスト
  # return ひっくり返した数
  def reverse(stones)

  end
end
