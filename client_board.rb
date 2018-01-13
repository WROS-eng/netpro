require "./base_board.rb"

class ClientBoard < BaseBoard
  #盤面の描画
  def pretty_print
    #x,yをSQUARESの回数ぶん回す
    for y in 0..SQUARES
      for x in 0..SQUARES
        # 端の列の1~8までの数字
        if y == 0 then
          if 1 < x && x < 10
            print " #{x - 1}"
          elsif print "  "
          end
        elsif x == 0 then
          if 1 < y && y < 10
            print " #{y - 1}"
          else
            print "  "
          end
          #石の描画
        else
          print_mark(get_square(x - 1, y - 1))
        end
      end
      puts #一列終わったら改行
    end
  end

  #そのままfor文に書くと複雑な見た目になるので、メソッド化
  def print_mark(field_value)
    if field_value == COLOR[:white]
      print MARK[:white]
    elsif field_value == COLOR[:black]
      print MARK[:black]
    elsif field_value == FIELD[:wall]
      print MARK[:wall]
    else
      print MARK[:blank]
    end
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
  def can_put_stone(x,y)
    return get_square(x,y) == FIELD[:blank]
  end
end