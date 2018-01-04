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

    #盤面の反転
    #Return値が0以上ならひっくり返すことができる
    def get_flip_count(color, x, y)
        result = 0
        if get_square(x,y) != FIELD[:blank] then 
            return 0
        end

        #一列ずつ見て行く.centerは置いた場所なので、見なくてよい
        result += get_flip_count_with_dir(color, x, y, DIR[:up_left])
        result += get_flip_count_with_dir(color, x, y, DIR[:up])
        result += get_flip_count_with_dir(color, x, y, DIR[:up_right])
        result += get_flip_count_with_dir(color, x, y, DIR[:left])
        result += get_flip_count_with_dir(color, x, y, DIR[:right])
        result += get_flip_count_with_dir(color, x, y, DIR[:down_left])
        result += get_flip_count_with_dir(color, x, y, DIR[:down])
        result += get_flip_count_with_dir(color, x, y, DIR[:down_right])
        
        return result
    end

    #一方向の盤面を返す処理
    def get_flip_count_with_dir(color, x, y, pos_dir)
        #resultが１以上なら一つ以上の石をひっくり返せるということ
        opponent_color = get_opponent_color(color)
        
        #pos_dirを足すだけの方法にするにはxとyを一つの変数にする必要がある
        put_pos =( y * SQUARES )+ x 

        #置いた場所からdirの方向に一つずれたところから探索
        pos = put_pos + pos_dir

        #置いたカラー以外の石ならdir方向に探索
        while (COLOR.values - [color]).include?(@field[pos]) do
            pos += pos_dir
            puts "Values =  #{COLOR.values - [color]} color = #{@field[pos]} pos_dir #{pos_dir}"
        end

        if @field[pos] != color then
            return 0
        end

        flip_count = 0
        pos -= pos_dir
        
        while pos != put_pos do
            flip_count += 1
            pos -= pos_dir
            puts "pos =  #{pos} put_pos = #{put_pos}"
        end

        return flip_count
    end

    def get_opponent_color(color)
        if color == COLOR[:white] then 
            return COLOR[:black]
        else
            return COLOR[:white]
        end
    end
end