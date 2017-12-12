class Client_Board
    # attr_reader :field
    # def initialize
    #     @field = Array.new(SQUARES+2){Array.new(SQUARES+2,0)}
    #     @field[4][4],@field[5][4],@field[5][5],@field[4][5] = 1,-1,1,-1
    # end
    
    # def initialize(field_data)
    #     @field = Array.new(SQUARES+2){Array.new(SQUARES+2,0)}
    #     @field = field_data
    # end

    # def updata_board_info(field_data)
    #     @field = field_data
    # end 

    # def showBoard
    #     puts "  1 2 3 4 5 6 7 8\n"
    #     for j in 1..SQUARES
    #         print "#{j}"
    #         for i in 1..SQUARES
    #             case @field[i][j]
    #             when 0
    #                 puts "\e[32m"
    #                 puts " □"
    #                 puts "\e[0m"
    #             when 1
    #                 puts " ○"
    #             when -1
    #                 puts " ●"
    #             end
    #         end
    #         puts "\n"
    #     end
    # end


    # def arround_check(nx,ny,player_color)
    #     x_root = Array.new
    #     y_root = Array.new
    #     @dx_root = Array.new
    #     @dy_root = Array.new
    #     max_count = 0
    #     for j in 0..2
    #         for i in 0..2
    #             if @field[nx+i-1][ny+j-1] == -1 * player_color
    #                 x_root << i-1
    #                 y_root << j-1
    #             end
    #         end
    #     end
    
    #     if x_root.length <= 0
    #         return false
    #     end
    
    #     for count in 0..x_root.length - 1
    #         empty_flag = 0
    #         x = x_root[count]
    #         y = y_root[count]
    #         dx = nx
    #         dy = ny
    #         while 1
    #             dx += x
    #             dy += y
    #             if dx > 8 || dy > 8 || dx < 1 || dy < 1
    #                 empty_flag = 1
    #                 break
    #             end
    
    #             if @field[dx][dy] == 0
    #                 empty_flag = 1
    #                 break
    #             end
    #             if @field[dx][dy] == player_color
    #                 break
    #             end
    #         end
    #     end

    #     if empty_flag == 0
    #         max_count += 1
    #         @dx_root << x_root[count]
    #         @dy_root << y_root[count]
    #     end
    # end
          
    #     if @dx_root.length > 0
    #       $max_put << max_count
    #       return true
    #     else
    #       return false
    #     end
    
    # end

    # def pass_check(player_color)
    #     for j in 1..SQUARES
    #         for i in 1..SQUARES
    #             if @field[i][j] != 0
    #                 next
    #             end
    #             if around_check(i,j,player_color)
    #                 return false
    #             end
    #         end
    #     end     
    #     $pass_count += 1
    #     return true
    # end
end