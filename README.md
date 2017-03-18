#TConnect4


The Odin Project : Ruby Programming : Testing Ruby With RSpec : Testing Ruby

Implements a commandline Connect4 game for two human players.  A computer player is not implemented.  There are 3 basic classes - Board, which models the board, checks for win and board full conditions, and allows players to add pieces; Player, allowing a player to make moves; and Connect4, which uses the Board and Player classes to play a game.  Board is thoroughly tested using RSpec, Player less so, and Connect4 not at all - I found it too difficult to put mock inputs feeding user input loops.  On the other hand, Board is by far the most complex class.