require "./base_board.rb"

class ClientBoard < BaseBoard
    
    #盤面の描画
    def pretty_print
        #x,yをSQUARESの回数ぶん回す
        SQUARES.times do |y|
            SQUARES.times do |x|
                #配列の番号によって、記号を書く
                print_mark(@field[y * SQUARES + x])
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
        elsif field_value == FIELD[:edge]
            print MARK[:edge]
        else
            print MARK[:none]
        end
    end

    #盤面の反転
    def flip_block
    end

    #一方向の盤面を返す処理
    def flip_line_block
    end
end