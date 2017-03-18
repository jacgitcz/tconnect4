require_relative "../connect4_board"

describe Board do
    before(:all) do
        @b = Board.new
    end

    describe '#get_colcount' do
    	it 'returns the number of columns in the board' do
    		expect(@b.get_colcount).to eq Board::MAXCOL+1
    	end
    end

    describe '#get_rowcount' do
    	it 'returns the number of rows in the board' do
    		expect(@b.get_rowcount).to eq Board::MAXROW+1
    	end
    end

    describe '#get_col_emptyspaces' do
    	it 'returns the number of empty spaces for a valid column' do
    		expect(@b.get_col_emptyspaces(0)).to eq Board::MAXROW+1
    		expect(@b.get_col_emptyspaces(3)).to eq Board::MAXROW+1
    		expect(@b.get_col_emptyspaces(6)).to eq Board::MAXROW+1
    	end
    	it 'returns an error value for an out of range column' do
    		expect(@b.get_col_emptyspaces(-1)).to eq Board::BADCOL
    		expect(@b.get_col_emptyspaces(7)).to eq Board::BADCOL
    	end
    end

    describe '#get_col' do
        it 'returns the contents of the specified column' do
            expect(@b.get_col(0)).to eq [0,0,0,0,0,0]
            expect(@b.get_col(1)).to eq [0,0,0,0,0,0]
            expect(@b.get_col(6)).to eq [0,0,0,0,0,0]
        end
        it 'returns an error value if the column value is illegal' do
            expect(@b.get_col(7)).to eq Board::BADCOL
            expect(@b.get_col(-1)).to eq Board::BADCOL
        end
    end

    describe '#add_piece' do
        it 'adds a player piece to an empty column' do
            @b.add_piece(1,0)
            expect(@b.get_col(0)).to eq [1,0,0,0,0,0]
        end
        it 'adds a piece to the next free space' do
            @b.clear_board
            @b.add_piece(2,3)
            expect(@b.get_col(3)).to eq [2,0,0,0,0,0]
            @b.add_piece(1,3)
            expect(@b.get_col(3)).to eq [2,1,0,0,0,0]
            @b.add_piece(1,3)
            expect(@b.get_col(3)).to eq [2,1,1,0,0,0]
        end
        it 'can fill a column' do
            @b.clear_board
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            expect(@b.get_col(5)).to eq [1,1,1,1,1,0]
            @b.add_piece(1,5)
            expect(@b.get_col(5)).to eq [1,1,1,1,1,1]
        end
        it 'returns the number of free spaces left' do
            @b.clear_board
            @b.add_piece(1,6)
            @b.add_piece(1,6)
            @b.add_piece(1,6)
            expect(@b.add_piece(1,6)).to eq 2
        end
        it 'returns an error value when attempting to add to a full column' do
            @b.clear_board
            @b.add_piece(2,1)
            @b.add_piece(2,1)
            @b.add_piece(2,1)
            @b.add_piece(2,1)
            @b.add_piece(2,1)
            @b.add_piece(2,1)
            expect(@b.add_piece(2,1)).to eq Board::FULLCOL
        end
        it 'returns an error value for an illegal player' do
            expect(@b.add_piece(3,0)).to eq Board::BADPLAYER
            expect(@b.add_piece(0,6)).to eq Board::BADPLAYER
        end
        it 'returns an error value for an illegal column' do
            expect(@b.add_piece(1,-1)).to eq Board::BADCOL
            expect(@b.add_piece(2,7)).to eq Board::BADCOL
        end
        it 'does not affect adjoining columns' do
            @b.clear_board
            @b.add_piece(1,3)
            expect(@b.getrow(0)).to eq [0,0,0,1,0,0,0]
            @b.add_piece(2,0)
            expect(@b.getrow(0)).to eq [2,0,0,1,0,0,0]
        end
    end

    describe '#next_pos' do
        it 'returns the next higher row position in CHECKCOL mode' do
            pos = [0,0]
            expect(@b.next_pos(pos, Board::CHECKCOL)).to eq [0,1]
            pos = [3,4]
            expect(@b.next_pos(pos, Board::CHECKCOL)).to eq [3,5]
        end
        it 'returns an error code if the next position is beyond the end of the line in CHECKCOL mode' do
            pos = [6,Board::MAXROW]
            expect(@b.next_pos(pos, Board::CHECKCOL)).to eq [Board::ENDLINE, Board::ENDLINE]
        end
        it 'returns the nex col position to the right in CHECKROW mode' do
            pos = [0,0]
            expect(@b.next_pos(pos, Board::CHECKROW)).to eq [1,0]
            pos = [2,4]
            expect(@b.next_pos(pos, Board::CHECKROW)).to eq [3,4]
        end
        it 'returns an error code if the next position is beyond the last column in CHECKROW mode' do
            pos = [Board::MAXCOL, 4]
            expect(@b.next_pos(pos, Board::CHECKROW)).to eq [Board::ENDLINE, Board::ENDLINE]
        end
        it 'returns the next rising diagonal position to the right in CHECKDIAG_RIGHT mode' do
            pos = [0,0]
            expect(@b.next_pos(pos, Board::CHECKDIAG_RIGHT)).to eq [1,1]
            pos = [3,4]
            expect(@b.next_pos(pos, Board::CHECKDIAG_RIGHT)).to eq [4,5]
        end
        it 'returns an error code if the next diagonal position would be off the board' do
            pos = [0, Board::MAXROW]
            expect(@b.next_pos(pos, Board::CHECKDIAG_RIGHT)).to eq [Board::ENDLINE, Board::ENDLINE]
            pos = [Board::MAXCOL, Board::MAXROW]
            expect(@b.next_pos(pos, Board::CHECKDIAG_RIGHT)).to eq [Board::ENDLINE, Board::ENDLINE]
            pos = [Board::MAXCOL, 4]
            expect(@b.next_pos(pos, Board::CHECKDIAG_RIGHT)).to eq [Board::ENDLINE, Board::ENDLINE]
        end
        it 'returns the next rising diagonal position to the left in CHECKDIAG_LEFT mode' do
            pos = [Board::MAXCOL, 0]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [Board::MAXCOL-1,1]
            pos = [4,3]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [3,4]
        end
        it 'returns an error code if the next diagonal position would be off the board' do
            pos = [0, Board::MAXROW]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [Board::ENDLINE, Board::ENDLINE]
            pos = [0,3]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [Board::ENDLINE, Board::ENDLINE]
            pos = [0,0]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [Board::ENDLINE, Board::ENDLINE]
            pos = [4, Board::MAXROW]
            expect(@b.next_pos(pos, Board::CHECKDIAG_LEFT)).to eq [Board::ENDLINE, Board::ENDLINE]
        end
    end

    describe '#checkline' do
        it 'returns false for an empty column in CHECKCOL mode' do
            @b.clear_board
            expect(@b.checkline(1,[3,0], Board::CHECKCOL)).to eq false
        end
        it 'returns false for column containing only the other player in CHECKCOL mode' do
            for i in 0..Board::MAXROW do
                @b.add_piece(2,1)
            end
            expect(@b.checkline(1,[1,0], Board::CHECKCOL)).to eq false
        end
        it 'returns false for column containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checkline(1,[5,0], Board::CHECKCOL)).to eq false
        end
        it 'returns true for column containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            expect(@b.checkline(1,[2,0], Board::CHECKCOL)).to eq true
        end
        it 'returns false for an empty row in CHECKROW mode' do
            @b.clear_board
            expect(@b.checkline(1,[0,3], Board::CHECKROW)).to eq false
        end
        it 'returns false for row containing only the other player in CHECKROW mode' do
            for i in 0..Board::MAXCOL do
                @b.add_piece(2,i)
            end
            expect(@b.checkline(1,[0,0], Board::CHECKROW)).to eq false
        end
        it 'returns false for row containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(1,2)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(1,5)
            expect(@b.checkline(1,[0,0], Board::CHECKROW)).to eq false
        end
        it 'returns true for row containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(1,2)
            @b.add_piece(1,3)
            @b.add_piece(1,4)
            expect(@b.checkline(1,[0,0], Board::CHECKROW)).to eq true
        end
        it 'returns false for an empty right diagonal in CHECKDIAG_RIGHT mode' do
            @b.clear_board
            expect(@b.checkline(1,[0,3], Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns false for a right diagonal containing only the other player in CHECKDIAG_RIGHT mode' do
            for j in 0..Board::MAXROW do
                for i in j..Board::MAXCOL do
                    @b.add_piece(2,i)
                end
            end
            expect(@b.checkline(1,[0,0], Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns false for row containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(2,3)
            @b.add_piece(2,3)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checkline(1,[0,0], Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns true for row containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(2,3)
            @b.add_piece(2,3)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(1,4)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checkline(1,[1,0], Board::CHECKDIAG_RIGHT)).to eq true
        end
        it 'returns false for an empty right diagonal in CHECKDIAG_LEFT mode' do
            @b.clear_board
            expect(@b.checkline(1,[Board::MAXCOL,0], Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns false for a right diagonal containing only the other player in CHECKDIAG_LEFT mode' do
            for j in 0..Board::MAXROW do
                for i in j..Board::MAXCOL do
                    @b.add_piece(2,i)
                end
            end
            expect(@b.checkline(1,[Board::MAXCOL,0], Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns false for row containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(1,Board::MAXCOL)
            @b.add_piece(2,Board::MAXCOL-1)
            @b.add_piece(1,Board::MAXCOL-1)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(1,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(1,Board::MAXCOL-4)
            expect(@b.checkline(1,[Board::MAXCOL,0], Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns true for row containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(1,Board::MAXCOL)
            @b.add_piece(2,Board::MAXCOL-1)
            @b.add_piece(1,Board::MAXCOL-1)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(1,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(1,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(1,Board::MAXCOL-4)
            expect(@b.checkline(1,[Board::MAXCOL,0], Board::CHECKDIAG_LEFT)).to eq true
        end
    end

    describe '#checklines' do
        it 'returns false for an empty column in CHECKCOL mode' do
            @b.clear_board
            expect(@b.checklines(1, Board::CHECKCOL)).to eq false
        end
        it 'returns false for column containing only the other player in CHECKCOL mode' do
            @b.clear_board
            for i in 0..Board::MAXROW do
                @b.add_piece(2,1)
            end
            expect(@b.checklines(1, Board::CHECKCOL)).to eq false
        end
        it 'returns false for column containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(1,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checklines(1, Board::CHECKCOL)).to eq false
        end
        it 'returns true for column containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            @b.add_piece(1,2)
            expect(@b.checklines(1, Board::CHECKCOL)).to eq true
        end
        it 'returns false for an empty row in CHECKROW mode' do
            @b.clear_board
            expect(@b.checklines(1, Board::CHECKROW)).to eq false
        end
        it 'returns false for row containing only the other player in CHECKROW mode' do
            @b.clear_board
            for i in 0..Board::MAXCOL do
                @b.add_piece(2,i)
            end
            expect(@b.checklines(1, Board::CHECKROW)).to eq false
        end
        it 'returns false for row containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(1,2)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(1,5)
            expect(@b.checklines(1, Board::CHECKROW)).to eq false
        end
        it 'returns true for row containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(1,2)
            @b.add_piece(1,3)
            @b.add_piece(1,4)
            expect(@b.checklines(1, Board::CHECKROW)).to eq true
        end
        it 'returns false for an empty right diagonal in CHECKDIAG_RIGHT mode' do
            @b.clear_board
            expect(@b.checklines(1, Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns false for a right diagonal containing only the other player in CHECKDIAG_RIGHT mode' do
            @b.clear_board
            for j in 0..Board::MAXROW do
                for i in j..Board::MAXCOL do
                    @b.add_piece(2,i)
                end
            end
            expect(@b.checklines(1, Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns false for right diagonal containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(2,3)
            @b.add_piece(2,3)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checklines(1, Board::CHECKDIAG_RIGHT)).to eq false
        end
        it 'returns true for right diagonal containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(2,3)
            @b.add_piece(2,3)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(1,4)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checklines(1, Board::CHECKDIAG_RIGHT)).to eq true
        end
        it 'returns false for an empty left diagonal in CHECKDIAG_LEFT mode' do
            @b.clear_board
            expect(@b.checklines(1, Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns false for a left diagonal containing only the other player in CHECKDIAG_LEFT mode' do
            @b.clear_board
            for j in 0..Board::MAXROW do
                for i in j..Board::MAXCOL do
                    @b.add_piece(2,i)
                end
            end
            expect(@b.checklines(1, Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns false for left diagonal containing less than 4 consecutive player pieces' do
            @b.clear_board
            @b.add_piece(1,Board::MAXCOL)
            @b.add_piece(2,Board::MAXCOL-1)
            @b.add_piece(1,Board::MAXCOL-1)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(1,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(1,Board::MAXCOL-4)
            expect(@b.checklines(1, Board::CHECKDIAG_LEFT)).to eq false
        end
        it 'returns true for left diagonal containing 4 or more consecutive player pieces' do
            @b.clear_board
            @b.add_piece(1,Board::MAXCOL)
            @b.add_piece(2,Board::MAXCOL-1)
            @b.add_piece(1,Board::MAXCOL-1)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(1,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(1,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(1,Board::MAXCOL-4)
            expect(@b.checklines(1, Board::CHECKDIAG_LEFT)).to eq true
        end
    end

    describe '#checkwin' do
        it 'returns false for an empty board' do
            @b.clear_board
            expect(@b.checkwin(1)).to eq false
            expect(@b.checkwin(2)).to eq false
        end
        it 'returns false for a board containing only the other player' do
            @b.clear_board
            for col in 0..Board::MAXCOL do
               for row in 0..Board::MAXROW do
                  @b.add_piece(2,col)
                end
            end
            expect(@b.checkwin(1)).to eq false
        end
        it 'returns true for a column of 4' do 
            @b.clear_board
            for row in 0..Board::MAXROW do
                @b.add_piece(1,3)
            end
            expect(@b.checkwin(1)).to eq true
        end
        it 'returns true for a row of 4' do
            @b.clear_board
            for i in 1..Board::MAXCOL-1 do
                @b.add_piece(2,i)
            end
            expect(@b.checkwin(2)).to eq true            
        end
        it 'returns true for a right diagonal of 4' do
            @b.clear_board
            @b.add_piece(2,0)
            @b.add_piece(1,1)
            @b.add_piece(2,2)
            @b.add_piece(1,2)
            @b.add_piece(2,3)
            @b.add_piece(2,3)
            @b.add_piece(1,3)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(2,4)
            @b.add_piece(1,4)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(2,5)
            @b.add_piece(1,5)
            expect(@b.checkwin(1)).to eq true
        end
        it 'returns true for a left diagonal of 4' do
            @b.clear_board
            @b.add_piece(1,Board::MAXCOL)
            @b.add_piece(2,Board::MAXCOL-1)
            @b.add_piece(1,Board::MAXCOL-1)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-2)
            @b.add_piece(1,Board::MAXCOL-2)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-3)
            @b.add_piece(1,Board::MAXCOL-3)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(2,Board::MAXCOL-4)
            @b.add_piece(1,Board::MAXCOL-4)
            expect(@b.checkwin(1)).to eq true
        end
    end

    describe '#board_full?' do
        it 'returns false for an empty board' do
            @b.clear_board
            expect(@b.board_full?).to eq false
        end
        it 'returns false for a board with one empty column' do
            @b.clear_board
            for col in 0..(Board::MAXCOL-1) do
                for row in 0..(Board::MAXROW) do
                    @b.add_piece(1,col)
                end
            end
            expect(@b.board_full?).to eq false            
        end
        it 'returns false for a board with just 1 free space' do
            @b.clear_board
            for col in 0..(Board::MAXCOL-1) do
                for row in 0..(Board::MAXROW) do
                    @b.add_piece(2,col)
                end
            end
            for row in 0..(Board::MAXROW-1) do
                @b.add_piece(2,Board::MAXCOL)
            end
            expect(@b.board_full?).to eq false
        end
        it 'returns true for a full board' do
            @b.clear_board
            for col in 0..(Board::MAXCOL) do
                for row in 0..(Board::MAXROW) do
                    @b.add_piece(1,col)
                end
            end
            expect(@b.board_full?).to eq true           
        end
    end
end