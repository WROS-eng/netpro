module System
  # プレイヤーの行動
  module InputType
    PUT = 1      # 置いた
    PASS = 2     # パス
    RETIRE = 3   # リタイア
    NONE = -1    # 未定義の行動
  end

  Result = Struct.new(:username, :result, :stone_cnt, :pass_cnt, :color)
end
