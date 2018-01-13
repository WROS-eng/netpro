require './base_board.rb'

# クライアントで扱うボードクラス
class ClientBoard < BaseBoard
  # 盤面の描画
  def pretty_print
    filed_marks =
      @field
      .map { |f| FIELD.key(f) }
      .map { |f| MARK[f] }
      .each_slice(SQUARES)
      .map { |f| f.join(' ') }

    print_range = 1..SQUARES - 2
    puts "     #{print_range.to_a.join(' ')}"
    puts "   #{filed_marks.first}"
    filed_marks[print_range].each_with_index { |f, i| puts " #{i + 1} #{f}" }
    puts "   #{filed_marks.last}"
  end

  # 指定マスに置いた際に反転する石の数を返す
  # x : 置くx座標
  # y : 置くy座標
  # color : 置く石の石の色
  # return 反転する石の数。1以上ならひっくり返すことができる
  def get_flip_count(color, x, y)
    get_flip_list(color, x, y).length
  end

  # 指定マスに石が置けるか
  # x : 置くx座標
  # y : 置くy座標
  # return true or false
  def can_put_stone(x, y)
    return get_square(x, y) == FIELD[:blank]
  end
end
