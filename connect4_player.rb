class Player
# Connect 4 player
  attr_reader :player
  attr_accessor :input, :output

  def initialize(player_num, board)
  	@player = player_num
  	@c4board = board
  	@maxcol = board.get_colcount - 1
  	@input = $stdin
  	@output = $stdout
  end

  def check_input(instr)
  	if instr.length != 1
  		return false
  	end
  	number = %r!\d{1}!
  	if (number =~ instr).nil?
  		return false
  	end
  	col = instr.to_i
  	if col < 0 or col > @maxcol
  		return false
  	end
  	true
  end

  # Todo - add routine to get input from player
  # Add make_move to correctly add to selected column, or report error if full
  
  def get_input
  	@output.puts "Enter the number of the column where you want to add a piece\n"
  	@output.puts "The column number should be between 0 and #{@maxcol}, or q to quit.\n"
  	@output.puts "Enter your column now: "
  	colstr = @input.gets.chomp
  	return colstr
  end

  def apply_move(column)
  	result = @c4board.add_piece(@player, column)
  end

  def move
  	good_move = false
  	quit = false
  	while not good_move and !quit do 
  	  colstring = get_input
  	  good_move = check_input(colstring)
  	  if good_move
  	  	col = colstring.to_i
  	  	colspaceleft = apply_move(col)
  	  	if colspaceleft < 0
  	  		good_move = false
  	  		@output.puts "You can't add to this column - try another one\n"
  	  	end
  	  else
  	  	if colstring == "q"
  	  		quit = true
  	  		break
  	  	else
  	  	    @output.puts "This is not a valid column number, try again\n"
  	  	end
  	  end
    end
    return quit
  end
end