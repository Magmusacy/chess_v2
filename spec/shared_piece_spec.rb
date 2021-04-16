RSpec.shared_examples 'base class methods names' do
  context 'when method is from the base class' do
    it 'responds to #move' do
      expect(subject).to respond_to(:move)
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