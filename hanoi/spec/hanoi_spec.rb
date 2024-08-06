require_relative '../lib/hanoi'

# Test sprawdza poprawne działanie głównego algorytmu układania wieży
# dla przykładowej wielkości 3 klocków. Pod koniec działania metody
# .solve oczekuje, że dwa pierwsze słupki będą pod koniec puste, a
# ostatni będzie zawierał od n do 1 malejąco. 
describe Hanoi do
  let(:n) { 3 }
  let(:hanoi) { Hanoi.new(n) }
  describe ".solve" do
    before do
      hanoi.solve
    end

    it 'poprawnie rozwiazuje zagadke' do

      expect(hanoi.instance_variable_get(:@rodA)).to be_empty
      expect(hanoi.instance_variable_get(:@rodB)).to be_empty
      expect(hanoi.instance_variable_get(:@rodC)).to eq([3, 2, 1])
    end
  end
end