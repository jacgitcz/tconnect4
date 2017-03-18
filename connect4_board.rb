class Board
# Connect 4 board
  MAXROW = 5    # 6 rows, so max row index will be 5
  MAXCOL = 6    # 7 cols
  BADCOL = -1
  BADPLAYER = -2
  FULLCOL = -9
  CHECKCOL = 1
  CHECKROW = 2
  CHECKDIAG_RIGHT = 3
  CHECKDIAG_LEFT = 4
  ENDLINE = -3
  ROUNDCOUNTER = "\u0020\u25EF\u0020"
  DIAMOND = "\u0020\u25A3\u0020"
  EMPTY = "\u0020\u0020\u0020"
  DISPLAY = [EMPTY, ROUNDCOUNTER, DIAMOND]
  
  # a zero value in a board position means that position is empty.

  def initialize
  	@board = Array.new(MAXCOL + 1){Array.new(MAXROW+1){0}}
    @colstart = Array.new(MAXCOL+1){Array.new(2){0}}
    @rowstart = Array.new(MAXROW+1){Array.new(2){0}}
    @diagright_start = Array.new(MAXCOL + MAXROW - 6){Array.new(2){0}}
    @diagleft_start = Array.new(MAXCOL + MAXROW - 6){Array.new(2){0}}

    set_startpos_lists
  end

  def clear_board
  	# empties the board
  	for column in 0..MAXCOL
  		for row in 0..MAXROW
  			@board[column][row] = 0
  		end
  	end
    set_startpos_lists
  end

  def set_startpos_lists
   # the xxxstart arrays define start of potential win lines

    for i in 0..MAXCOL
      @colstart[i] = [i,0]
    end
    for i in 0..MAXROW
      @rowstart[i] = [0,i]
    end
    for i in 0..MAXROW-3
      @diagright_start[i] = [0,i]
    end
    for i in MAXCOL-3..MAXCOL-1
      @diagright_start[i] = [i-2,0]
    end
    for i in 0..MAXROW-3
      @diagleft_start[i] = [MAXCOL,i]
    end
    for i in MAXCOL-3..MAXCOL-1
      @diagleft_start[i] = [i+1,0]
    end
  end

  def add_piece(player, column)
  	# Attempts to add a player piece to the given column.
  	# Return values : valid move - the number of free spaces left after the move
  	if player.between?(1,2)
  		if column.between?(0, MAXCOL)
  			first_emptypos = @board[column].index(0)
  			if first_emptypos.nil?  # there are no free spaces
  				return FULLCOL
  			else
  				@board[column][first_emptypos] = player
  				return get_col_emptyspaces(column)
  			end
  		else # column error
  			return BADCOL
  		end
  	else
  		return BADPLAYER
  	end
  end

  def check_win
  	# check for win condition
  end

  def get_colcount
  	# returns the number of columns in the board
  	return @board.length
  end

  def get_rowcount
  	# returns the number of rows in the board
  	# assumes that all columns have the same number of rows
  	return @board[0].length
  end

  def getrow(row)
    rowcontents = []
    for i in 0..MAXCOL
      rowcontents << @board[i][row]
    end
    return rowcontents
  end

  def get_col_emptyspaces(column)
  	# returns the number of empty spaces left in a column.
  	# result will be 0 <= x <= rowcount
  	# returns a negative value for an illegal column count
  	if column.between?(0, MAXCOL)
  	    return @board[column].count(0)
  	else
  		return BADCOL
  	end
  end

  def get_col(column)
    if column.between?(0, MAXCOL)
      return @board[column]
    else
      return BADCOL
    end
  end

  def next_pos(pos, mode)
    # returns the next position in a column, row, right or left diagonal
    case mode
    when CHECKCOL
      pos[1] += 1
      if pos[1] > MAXROW
        return [ENDLINE, ENDLINE]
      else
        return pos
      end
    when CHECKROW
      pos[0] += 1
      if pos[0] > MAXCOL
        return [ENDLINE, ENDLINE]
      else
        return pos
      end
    when CHECKDIAG_RIGHT
      pos[0] += 1
      pos[1] += 1
      if pos[0] > MAXCOL or pos[1] > MAXROW
        return [ENDLINE, ENDLINE]
      else
        return pos
      end
    when CHECKDIAG_LEFT
      pos[0] -= 1
      pos[1] += 1
      if pos[0] < 0 or pos[1] > MAXROW
        return [ENDLINE, ENDLINE]
      else
        return pos
      end
    end
  end

  def checkline(player, linestart, mode)
    # checks the line starting at linestart for a win condition
    # win condition - 4 player pieces consecutively along the line
    # mode - selects column, row, right or left diagonal
    win = false
    count = 0
    lpos = linestart
    until lpos[0] == ENDLINE do
      pieceval = @board[lpos[0]][lpos[1]]
      if pieceval == player
        count += 1
        if count >= 4
          win = true
          break
        end
      else
        count = 0
      end
      lpos = next_pos(lpos, mode)
    end
    return win
  end

  def checklines(player, mode)
    set_startpos_lists
    case mode
    when CHECKCOL
      startpos = @colstart[0..@colstart.length]
    when CHECKROW
      startpos = @rowstart[0..@rowstart.length]
    when CHECKDIAG_RIGHT
      startpos = @diagright_start[0..@diagright_start.length]
    when CHECKDIAG_LEFT
      startpos = @diagleft_start[0..@diagleft_start.length]
    end

    win = false
    for spos in startpos
      win = checkline(player, spos, mode)
      if win == true
        break
      end
    end
    return win
  end

  def checkwin(player)
    win = false
    win = checklines(player, CHECKCOL)
    if win
      return true
    end
    win = checklines(player, CHECKROW)
    if win
      return true
    end
    win = checklines(player, CHECKDIAG_RIGHT)
    if win
      return true
    end
    win = checklines(player, CHECKDIAG_LEFT)
    if win
      return true
    end
    false
  end

  def display_board
    # displays the board on the console
    # display column numbers
    print "\n"
    for i in 0..MAXCOL do
      print "--#{i}-"
    end
    print "-\n"
    for i in MAXROW.downto(0) do
      print_boardrow(i)
    end
    print "\n"
  end

  def print_boardrow(row)
    for j in 0..MAXCOL do
      contents = @board[j][row]
      print "|", DISPLAY[contents]
    end
    print "|\n"
    for j in 0..MAXCOL do
      print "----"
    end
    print "-\n"
  end

  def board_full?
    # returns true if the board is full - no possible moves - false otherwise
    result = true
    for col in 0..MAXCOL do
      spaces_in_col = get_col_emptyspaces(col)
      if spaces_in_col > 0
        result = false
        break
      end
    end
    result
  end
end