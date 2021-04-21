require_relative '../lib/game'
require_relative '../lib/player'
#require_relative '../lib/board'

describe Game do
  describe '#player_move' do
    subject(:player_game) { described_class.new }

    context 'when given player is :human' do
      let(:human_player) { double('Player', type: :human) }

      before do
        allow(player_game).to receive(:human_move).with(human_player)
      end

      it 'calls #human_move method' do
        expect(player_game).to receive(:human_move).with(human_player)
        player_game.player_move(human_player)
      end
    end

    context 'when given player is :ai' do
      let(:ai_player) { double('Player', type: :ai) }

      before do
        allow(player_game).to receive(:ai_move).with(ai_player)
      end

      it 'calls #ai_move method' do
        expect(player_game).to receive(:ai_move).with(ai_player)
        player_game.player_move(ai_player)
      end
    end
  end

  describe '#correct_input?' do
    let(:chess_board) { double('Board') }
    subject(:move_game) { described_class.new(nil, nil, chess_board) }
    context 'when player color is :white' do
      let(:wht_player) { double('player', color: :white) }
      let(:wht_square1) { double('square', position: { x: 4, y: 4 }) }
      let(:wht_square2) { double('square', position: { x: 5, y: 4 }) }
      context 'when square with given input position has :white Piece' do
        it 'returns true' do
          allow(chess_board).to receive(:get_player_squares).with(wht_player).and_return([wht_square1, wht_square2])
          result = move_game.correct_input?(wht_player, wht_square1)
          expect(result).to be true
        end
      end

      context 'when square with given input position has :black Piece' do
        let(:blk_square) { double('square', position: { x: 2, y: 6 }) }
        it 'returns false' do
          allow(chess_board).to receive(:get_player_squares).with(wht_player).and_return([wht_square1, wht_square2])
          result = move_game.correct_input?(wht_player, blk_square)
          expect(result).to be false
        end
      end
    end
  end

  describe '#correct_move?' do
    let(:given_move) { double('square') }
    let(:square_piece) { double('piece') }
    let(:curr_square) { double('square', piece: square_piece) }
    let(:chess_board) { double('Board') }
    subject(:move_game) { described_class.new(nil, nil, chess_board) }

    context 'when given square\'s Piece #legal_moves include given move' do

      it 'returns true' do
        allow(square_piece).to receive(:legal_moves).with(chess_board).and_return([given_move])
        result = move_game.correct_move?(curr_square, given_move)
        expect(result).to be true
      end
    end

    context 'when given square\'s Piece #legal_moves doesn\'t include given move' do

      it 'returns false' do
        allow(square_piece).to receive(:legal_moves).with(chess_board).and_return([])
        result = move_game.correct_move?(curr_square, given_move)
        expect(result).to be false
      end
    end
  end

  describe '#get_correct_square' do
    let(:chess_board) { double('Board') }
    subject(:get_game) { described_class.new(nil, nil, chess_board) }

    context 'when given given correct input for :white Player' do
      let(:wht_player) { double('player', color: :white) }
      let(:square_input) { double('square', position: { x: 4, y: 4 }) }

      before do
        input = { x: 4, y: 4 }
        allow(wht_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(wht_player, square_input).and_return(true)
      end

      it 'returns that square with that input as a position' do
        result = get_game.get_correct_square(wht_player)
        expect(result).to eq(square_input)
      end
    end

    context 'when given wrong input 2 times for :black Player' do
      let(:blk_player) { double('player', color: :black) }
      let(:square_input) { double('square', position: { x: 6, y: 4 }) }

      before do
        input = { x: 6, y: 4 }
        allow(blk_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(blk_player, square_input).and_return(false, false, true)
      end

      it 'displays error message 2 times' do
        error_message = "Wrong square, you can only choose black pieces"
        expect(get_game).to receive(:puts).with(error_message).twice
        result = get_game.get_correct_square(blk_player)
      end
    end

    context 'when given wrong input 1 time for :white Player' do
      let(:wht_player) { double('player', color: :white) }
      let(:square_input) { double('square', position: { x: 6, y: 4 }) }

      before do
        input = { x: 6, y: 4 }
        allow(wht_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_input)
        allow(get_game).to receive(:correct_input?).with(wht_player, square_input).and_return(false, true)
      end

      it 'displays error message 1 time' do
        error_message = "Wrong square, you can only choose white pieces"
        expect(get_game).to receive(:puts).with(error_message).once
        result = get_game.get_correct_square(wht_player)
      end
    end
  end

  describe '#human_move' do

    let(:piece) { double('piece') }
    let(:initial_square) { double('square', piece: piece) }
    let(:square_move) { double('square', position: { x: 6, y: 4 }) }
    let(:human_player) { double('player') }
    let(:chess_board) { double('board') }
    subject(:human_game) { described_class.new(nil, nil, chess_board) }

    context 'when specified correct move input' do
      before do
        input = { x: 6, y: 4 }
        allow(human_game).to receive(:display_board)
        allow(human_game).to receive(:get_correct_square).with(human_player).and_return(initial_square)
        allow(human_game).to receive(:correct_move?).with(initial_square, square_move).and_return(true)
        allow(human_player).to receive(:input).and_return(input)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_move)
      end

      it 'sends :move message with correct square to Piece on given square' do
        expect(piece).to receive(:move).with(square_move)
        human_game.human_move(human_player)
      end
    end

    context 'when specified wrong move input 2 times' do
      before do
        input = { x: 6, y: 4 }
        allow(human_game).to receive(:display_board)
        allow(human_player).to receive(:input).and_return(input)
        allow(piece).to receive(:move)
        allow(human_game).to receive(:get_correct_square).with(human_player).and_return(initial_square)
        allow(human_game).to receive(:correct_move?).with(initial_square, square_move).and_return(false, false, true)
        allow(chess_board).to receive(:get_square).with(input).and_return(square_move)
      end

      it 'displays error message 2 times' do
        error_message = 'Wrong move!'
        expect(human_game).to receive(:puts).with(error_message).twice
        human_game.human_move(human_player)
      end
    end
  end

  describe '#ai_move' do # contains logic for player movement if type == :ai
    let(:chess_board) { double('chess_board') }
    let(:ai_game) { described_class.new(nil, nil, chess_board) }
    let(:ai_player) { double('player_ai', type: :ai) }
    let(:ai_piece) { double('piece') }
    let(:ai_picked_square) { double('square', piece: ai_piece) }
    let(:legal_moves) { [ double('square') ] }

    before do
      allow(ai_player).to receive(:ai_pick_square).and_return(ai_picked_square)
      allow(ai_piece).to receive(:legal_moves).with(chess_board).and_return(legal_moves)
      allow(ai_player).to receive(:ai_pick_legal_move).with(legal_moves).and_return(legal_moves[0])
    end

    it 'sends :move message to random piece with random legal move' do
      expect(ai_piece).to receive(:move).with(legal_moves[0])
      ai_game.ai_move(ai_player)
    end
  end
end