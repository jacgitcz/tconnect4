require_relative "connect4_board"
require_relative "connect4_player"

class Connect4
	# connect 4 main game
	# sets up board and player objects, then loops until win or no moves left
	# !!! will need to add to Board a "full board" detector, corresponding changes to player and tests
	def initialize
		@board = Board.new
		@player1 = Player.new(1, @board)
		@player2 = Player.new(2, @board)
		@players = [@player1, @player2]
		@win = false
		@board_full = false
	end

	def play
		@board.clear_board
		@win = false
		@board_full = false
		currplayer_choice = 0
		player_num = 1
		quit = false
		while !@win & !@board_full & !quit do
			@board.display_board
			curr_player = @players[currplayer_choice]
			player_num = currplayer_choice + 1
			print "Player #{player_num}, your turn:\n"
			quit = curr_player.move
			@win = @board.checkwin(player_num)
			if !@win
				if !quit
				    currplayer_choice = (currplayer_choice +1) % 2
				end
			end
			@board_full = @board.board_full?
		end

		print "\nGame finished...\n"

		@board.display_board

		if @win
			print "Congratulations, player #{player_num}, you won!\n"
		elsif quit
			print "So, you gave up - OK..."
		else
			print "It looks as if nobody won..."
		end
	end
end