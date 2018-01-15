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

    puts "\n      #{print_range.map{|i|  i.to_s.rjust(2)}.join}"
    puts "    #{filed_marks.first}"
    filed_marks[print_range].each_with_index { |f, i| puts " #{(i + 1).to_s.rjust(2)} #{f}" }
    puts "    #{filed_marks.last}\n\n"
  end

  # 指定マスに石が置けるか
  # x : 置くx座標
  # y : 置くy座標
  # return true or false
  def can_put_stone(x, y)
    return get_square(x, y) == FIELD[:blank]
  end
end
