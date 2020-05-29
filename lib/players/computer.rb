require 'pry'
module Players
  class Computer < Player
    WIN_COMBINATIONS = [
      [1,2,3],
      [4,5,6],
      [7,8,9],
      [1,4,7],
      [2,5,8],
      [3,6,9],
      [1,5,9],
      [3,5,7]
    ]
   
    OPPOSITE_CORNERS = {
      1 => 9,
      3 => 7,
      7 => 3,
      9 => 1
      }
      
    # Move method contains logic 
    # to determine the proper move
    def move(board)
      # 1 check for any one move wins
      if can_win_self?(board) != false
        return can_win_self?(board).to_s
      
      # 2 check for blocking one move wins
      elsif can_win_opponent?(board) != false
        return can_win_opponent?(board).to_s
      
      # 3 take center if open
      elsif can_take_center?(board) == true
        return 5.to_s
      
      # 4 take corner opposite opponent corner
      elsif can_opposite_corner?(board).compact == true
        return can_opposite_corner?(board).to_s
      
      # 5 take first empty corner
      elsif can_corner?(board)
        return can_corner?(board).to_s
      
      # 6 take first empty side
      elsif side_available?(board) != false
        return side_available?(board).to_s
      end
    end
  
    # =====================================
    # Checks for any one move wins
    # returns array of win combos
    def get_winning_combos(board)
      combos = WIN_COMBINATIONS.collect do |combo|
        if combo.count {|p| board.taken?(p) == true} == 2
          tokens = combo.collect {|p| board.position(p) if board.taken?(p)}
          combo if tokens.compact.all? {|t| t == tokens[0]}
        end
      end
      combos.compact
    end
    # =====================================
    # 1 check for any one move wins
    # return false if none return 
    # position if exists
    def can_win_self?(board)
      combos = get_winning_combos(board)
      combos.each do |combo|
        tokens = combo.collect {|p| board.position(p) if board.taken?(p)}
        if tokens.compact[0] == self.token
          return combo.find {|p| board.taken?(p) == false}
        end
      end
      false
    end
    # =====================================
    # 2 check for blocking one move wins
    # return false if no opportunities return position if exists
    def can_win_opponent?(board)
      opponent_token = self.token == "X" ? "O" : "X"
      combos = get_winning_combos(board)
      combos.each do |combo|
        tokens = combo.collect {|p| board.position(p) if board.taken?(p)}
        if tokens.compact[0] == opponent_token
          return combo.find {|p| board.taken?(p) == false}
        end
      end
      false
    end
    
    # =====================================
    # 5 take center if open
    # return false if taken return center if valid
    def can_take_center?(board)
      board.taken?(5) ? false : true
    end
    
    # =====================================
    # 6 take corner opposite opponent corner
    # returns false if no opportunities return position if exists
    def can_opposite_corner?(board)
      [1,3,7,9].collect do |corner|
        if board.taken?(corner) == false
          op_corner = OPPOSITE_CORNERS[corner]
          if board.taken?(op_corner) && board.position(op_corner) != self.token
            corner
          end
        end
      end
    end
    
    # =====================================
    # 7 take an empty corner
    # return false if all corners taken else return first corner available
    def can_corner?(board)
      # CORNERS.find {|p| board.valid_move?(p)}
      [1,3,7,9].find {|p| board.valid_move?(p)}
    end
    
    # =====================================
    # 8 take empty side
    # return false if sides taken else return first side
    def side_available?(board)
      # SIDES.find {|p| board.valid_move?(p)}
      [2,6,8,4].find {|p| board.valid_move?(p)}
    end
  end
end




