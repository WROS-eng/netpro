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
                    elsif 
                        print "  "
                    end
                elsif x == 0 then
                    if 1 < y && y < 10
                        print " #{y - 1}"
                    else 
                        print "  "
                    end
                #石の描画
                else
                    print_mark(get_square(x - 1,y - 1))
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

    # 指定マスに置いた際に反転する石リストを返す処理
    # x : 置くx座標
    # y : 置くy座標
    # color : 置く石の石の色
    # return result : 反転する石のindexリスト。リストの長さが1以上ならひっくり返すことができる
    def get_flip_list(color, x, y)
        result = []

        # 置けるのは空きマスのときだけ
        if get_square(x,y) == FIELD[:blank] then
            #一列ずつ見て行く.centerは置いた場所なので、見なくてよい
            result += get_flip_list_with_dir(color, x, y, DIR[:up_left])
            result += get_flip_list_with_dir(color, x, y, DIR[:up])
            result += get_flip_list_with_dir(color, x, y, DIR[:up_right])
            result += get_flip_list_with_dir(color, x, y, DIR[:left])
            result += get_flip_list_with_dir(color, x, y, DIR[:right])
            result += get_flip_list_with_dir(color, x, y, DIR[:down_left])
            result += get_flip_list_with_dir(color, x, y, DIR[:down])
            result += get_flip_list_with_dir(color, x, y, DIR[:down_right])
        end

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
        put_pos = xy2index(x,y)

        # 置いた場所からdirの方向に一つずれたところから探索
        pos = put_pos + flip_dir

        flip_list = []
        # 置いたカラー以外の色ならdir方向に探索
        while (COLOR.values - [color]).include?(@field[pos]) do
            flip_list.push(pos)
            pos += flip_dir
            puts "Values =  #{COLOR.values - [color]} color = #{@field[pos]} pos_dir #{flip_dir}"
        end

        # 探索終了したマスが置いた色と異なる場合はリストをクリア
        flip_list.clear if @field[pos] != color

        return flip_list
    end
end