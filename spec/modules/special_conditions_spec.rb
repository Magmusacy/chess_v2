require_relative '../../lib/modules/special_conditions'
require_relative '../../lib/player'

RSpec.configure do |c|
  c.include SpecialConditions
end

describe '#check?' do
  let(:chess_board) { double('Board') }
  context 'when checked_player is :white player, and opponent is :black player' do
    let(:checked_player_color) { :white }
    let(:opponent_color) { :black }

    context 'when any :black player\'s pieces attack :white player\'s king' do
      let(:wht_king) { double('King') }
      let(:wht_square) { double('Square', piece: wht_king) }
      let(:blk_piece) { double('Piece') }
      let(:blk_square) { double('Square', piece: blk_piece) }

      before do
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([wht_square])
        allow(chess_board).to receive(:get_king_square).with(checked_player_color).and_return(wht_square)
        allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return([blk_square])
      end

      it 'returns true' do
        result = check?(chess_board, checked_player_color, opponent_color)
        expect(result).to be true
      end
    end
  end

  context 'when checked_player is :black player, and opponent is :white player' do
    let(:checked_player_color) {:black }
    let(:opponent_color) { :white }
    let(:blk_king) { double('King') }
    let(:wht_piece) { double('Piece') }
    let(:blk_square) { double('Square', piece: blk_king) }
    let(:wht_square) { double('Square', piece: wht_piece) }

    context 'when any :white player\'s pieces attack :black player\'s king' do
      before do
        allow(wht_piece).to receive(:legal_moves).with(chess_board).and_return([blk_square])
        allow(chess_board).to receive(:get_king_square).with(checked_player_color).and_return(blk_square)
        allow(chess_board).to receive(:squares_taken_by).with(opponent_color).and_return([wht_square])
      end

      it 'returns true' do
        result = check?(chess_board, checked_player_color, opponent_color)
        expect(result).to be true
      end
    end

    context 'when none of :white player\'s pieces attack :black player\'s king' do
      before do
        allow(wht_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:get_king_square).with(:black).and_return(blk_square)
        allow(chess_board).to receive(:squares_taken_by).with(:white).and_return([wht_square])
      end

      it 'returns false' do
        result = check?(chess_board, checked_player_color, opponent_color)
        expect(result).to be false
      end
    end
  end

end

describe '#mate?' do
  let(:chess_board) { double('Board') }

  context 'when mated_player is :black player, and opponent is :white player' do
    let(:checked_player_color) { :black }
    let(:opponent_color) { :white }
    let(:blk_piece) { double('Piece') }
    let(:blk_square) { double('Square', piece: blk_piece) }

    context 'when :black player is in check, and all of his pieces have no legal moves' do
      before do
        allow(self).to receive(:check?).with(chess_board, checked_player_color, opponent_color).and_return(true)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(checked_player_color).and_return([blk_square])
      end

      it 'returns true' do
        result = checkmate?(chess_board, checked_player_color, opponent_color)
        expect(result).to be true
      end
    end

    context 'when :black player is not in check, and all of his pieces have no legal moves' do
      before do
        allow(self).to receive(:check?).with(chess_board, checked_player_color, opponent_color).and_return(false)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(checked_player_color).and_return([blk_square])
      end

      it 'returns false' do
        result = checkmate?(chess_board, checked_player_color, opponent_color)
        expect(result).to be false
      end
    end

    context 'when :black player is in check, and some of his pieces have legal moves' do
      let(:move_square) { double('Square') }

      before do
        allow(self).to receive(:check?).with(chess_board, checked_player_color, opponent_color).and_return(true)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
        allow(chess_board).to receive(:squares_taken_by).with(checked_player_color).and_return([blk_square])
      end

      it 'returns false' do
        result = checkmate?(chess_board, checked_player_color, opponent_color)
        expect(result).to be false
      end
    end
  end
end

describe '#stalemate?' do
  let(:chess_board) { double('Board') }

  context 'when stalemated_player is :black player, and opponent is :white player' do
    let(:stalemated_player_color) { :black }
    let(:opponent_color) { :white }
    let(:blk_piece) { double('Piece') }
    let(:blk_square) { double('Square', piece: blk_piece) }

    context 'when :black player is not in check, and all of his pieces have no legal moves' do
      before do
        allow(self).to receive(:check?).with(chess_board, stalemated_player_color, opponent_color).and_return(false)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(stalemated_player_color).and_return([blk_square])
      end

      it 'returns true' do
        result = stalemate?(chess_board, stalemated_player_color, opponent_color)
        expect(result).to be true
      end
    end

    context 'when :black player is in check, and all of his pieces have no legal moves' do
      before do
        allow(self).to receive(:check?).with(chess_board, stalemated_player_color, opponent_color).and_return(true)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([])
        allow(chess_board).to receive(:squares_taken_by).with(stalemated_player_color).and_return([blk_square])
      end

      it 'returns false' do
        result = stalemate?(chess_board, stalemated_player_color, opponent_color)
        expect(result).to be false
      end
    end

    context 'when :black player is not in check, and all some of his pieces have legal moves' do
      let(:move_square) { double('Square') }

      before do
        allow(self).to receive(:check?).with(chess_board, stalemated_player_color, opponent_color).and_return(false)
        allow(blk_piece).to receive(:legal_moves).with(chess_board).and_return([move_square])
        allow(chess_board).to receive(:squares_taken_by).with(stalemated_player_color).and_return([blk_square])
      end

      it 'returns false' do
        result = stalemate?(chess_board, stalemated_player_color, opponent_color)
        expect(result).to be false
      end
    end
  end
end
