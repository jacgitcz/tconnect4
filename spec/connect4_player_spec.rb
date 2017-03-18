require_relative "../connect4_player"
require_relative "../connect4_board"

describe Player do
	before(:all) do
		@b = Board.new
		@p1 = Player.new 1, @b
		@p2 = Player.new 2, @b
		
	end

	describe '#check_input' do
		it 'returns true for valid column value' do
			expect(@p1.check_input("0")).to eq true
			expect(@p2.check_input(Board::MAXCOL.to_s)).to eq true
		end
		it 'returns false for an out of range column value' do
			expect(@p1.check_input("-1")).to eq false
			expect(@p2.check_input((Board::MAXCOL + 1).to_s)).to eq false
		end
		it 'returns false for empty input' do
			expect(@p2.check_input("")).to eq false
			expect(@p1.check_input("")).to eq false
		end
		it 'returns false for non-numeric input' do
			expect(@p1.check_input("a1z2")).to eq false
			expect(@p2.check_input("2bcd")).to eq false
		end
		it 'returns false for non-integer input' do
			expect(@p1.check_input("1.234")).to eq false
			expect(@p2.check_input("2.718")).to eq false
		end
	end

	describe '#get_input' do
		it 'returns the input string' do
			@p1.input = StringIO.new("7")
			expect(@p1.get_input).to eq "7"
		end
	end

	describe '#apply_move' do
		it 'returns the number of free spaces left in a column' do
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW) 
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW-1) 
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW-2) 
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW-3) 
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW-4) 
			rowsleft = @p2.apply_move(3)
			expect(rowsleft).to eq (Board::MAXROW-5) 
		end

		it 'returns an error code if the column is already full' do
			maxrows = Board::MAXROW
			maxrows -= 1
			for row in 0..maxrows do
				rowsleft = @p1.apply_move(0)
			end			
			rowsleft = @p1.apply_move(0)
			expect(rowsleft).to eq 0
			rowsleft = @p1.apply_move(0)
			expect(rowsleft).to be < 0
		end
	end
end