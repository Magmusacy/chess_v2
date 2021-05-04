RSpec.shared_examples 'base class methods names' do
  context 'when method is from the base class' do
    it 'responds to #move' do
      expect(subject).to respond_to(:move)
    end

    it 'responds to #discard_illegal_moves' do
      expect(subject).to respond_to(:discard_illegal_moves)
    end
  end
end

RSpec.shared_examples 'shared method names' do
  context 'when method names are the same' do
    it 'responds to #legal_moves' do
      expect(subject).to respond_to(:legal_moves)
    end
  end
end