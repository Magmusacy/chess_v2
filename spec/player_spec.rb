# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/square'
require_relative '../lib/board'

describe Player do
  subject(:player_human) { described_class.new(:black, :human) }

  describe '#input' do
    context 'when player is human' do
      context 'when given input is invalid' do
        before do
          allow(player_human).to receive(:gets).and_return('taco')
          allow(player_human).to receive(:translate_input)
          allow(player_human).to receive(:verify_input).and_return(nil, 'b2')
        end

        it 'outputs error message' do
          error_msg = 'Wrong square specified, to specify square type first it\'s column, then it\'s row like: b2'
          expect(player_human).to receive(:puts).with(error_msg).once
          player_human.input
        end
      end

      context 'when given input is valid' do
        before do
          allow(player_human).to receive(:gets).and_return('b2')
          allow(player_human).to receive(:translate_input)
          allow(player_human).to receive(:verify_input).and_return({ x: 2, y: 2 })
        end

        it 'doesn\'t output error message' do
          error_msg = 'Wrong square specified, to specify square type first it\'s column, then it\'s row like: b2'
          expect(player_human).not_to receive(:puts).with(error_msg)
          player_human.input
        end
      end
    end
  end

  describe '#verify_input' do
    context 'when given input string \'b2\'' do
      it 'returns given input' do
        input = 'b2'
        result = player_human.verify_input(input)
        expect(result).to eq(input)
      end
    end

    context 'when given input string length is not 2' do
      it 'returns nil' do
        input = 'bb2'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end

    context 'when given input string first character is not between(\'a\'..\'h\')' do
      it 'returns nil' do
        input = 'j2'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end

    context 'when given input string second character is not between(\'1\'..\'8\')' do
      it 'returns nil' do
        input = 'a9'
        result = player_human.verify_input(input)
        expect(result).to eq(nil)
      end
    end
  end

  describe '#translate_input' do
    context 'when given string \'a3\'' do
      it 'returns hash { x: 1, y: 3 }' do
        input = 'a3'
        result = player_human.translate_input(input)
        expected = { x: 1, y: 3 }
        expect(result).to eq(expected)
      end
    end
  end

  describe '#ai_pick_square' do
    subject(:player_ai) { described_class.new(:black, :ai) }
    let(:ai_board) { Array(1..8).product(Array(1..8)) }
    let(:chess_board) { instance_double(Board) }

    context 'when player\'s only piece #legal_moves is not empty' do
      let(:black_piece) { instance_double(Piece, color: :black) }
      before do
        pick_sqr_brd = ai_board.map do |pos|
          if [[7, 7]].include?(pos) # what the fuck is this  thing doing???
            instance_double(Square, position: { x: pos.first, y: pos.last }, piece: black_piece)
          else
            instance_double(Square, position: { x: pos.first, y: pos.last }, piece: '   ')
          end
        end

        allow(chess_board).to receive(:board).and_return(pick_sqr_brd)

        # since we only check if legal_moves is empty or not
        allow(black_piece).to receive(:legal_moves).and_return([:not_empty_array])
      end

      it 'returns random square with piece that has legal_moves and has the same color as this AI player' do
        board = chess_board.board
        expected_square = board.find { |sqr| sqr.position == { x: 7, y: 7 } }
        expect(player_ai.ai_pick_square(board)).to eq(expected_square)
      end
    end

    context 'when player\'s only piece #legal_moves is empty' do
      let(:black_piece) { instance_double(Piece, color: :black) }
      before do
        pick_sqr_brd = ai_board.map do |pos|
          if [1, 7].include?(pos)
            instance_double(Square, position: { x: pos.first, y: pos.last }, piece: black_piece)
          else
            instance_double(Square, position: { x: pos.first, y: pos.last }, piece: '   ')
          end
        end

        allow(chess_board).to receive(:board).and_return(pick_sqr_brd)
        allow(black_piece).to receive(:legal_moves).and_return([])
      end

      it 'returns nil' do
        board = chess_board.board
        expect(player_ai.ai_pick_square(board)).to be_nil
      end
    end
  end

  describe '#ai_pick_legal_move' do
    subject(:player_ai) { described_class.new(:black, :ai) }

    context 'when given not empty #legal_moves array' do
      let(:legal_moves) { [instance_double(Square), instance_double(Square), instance_double(Square)] }

      it 'returns square from #legal_moves' do
        expect(legal_moves).to include(player_ai.ai_pick_legal_move(legal_moves))
      end
    end
  end
end
