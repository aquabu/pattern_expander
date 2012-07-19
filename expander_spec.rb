require 'rspec'
require 'expander'
describe Expander do
  let(:wildcard) { ['a','b','c'] }

  describe '.parse' do
    it 'breaks a string into an array of patterns' do
      pending
    end
  end

  describe ".combine" do
    it "combines two arrays" do 
      subject.combine([:a,:b], [1,2,3]).should == [ 
        [:a,1],[:a,2],[:a,3], 
        [:b,1], [:b,2], [:b,3] ]
    end

    it 'flattens permutations of sub arrays (needed for recursion)' do
      subject.combine([[:a,:b],[:c]],[1]).should == [[:a,:b,1], [:c, 1]]
    end
  end

  it '.expand combines lists of arrays' do
    subject.expand([:a,:b],[1,2],[:c,:d]).should == [[:a, 1, :c],
      [:a, 1, :d],
      [:a, 2, :c],
      [:a, 2, :d],
      [:b, 1, :c],
      [:b, 1, :d],
      [:b, 2, :c],
      [:b, 2, :d]]
  end

  context 'with longer lists' do
    let(:list) { ['a'..'c', 'A'..'C' ,1..3, 11..13] }
    it 'combines lots of arrays' do
      expect { 
        subject.expand(*list)
      }.to_not raise_error
    end
    it 'has the expected number of permutations' do
      expected_count = 1 
      list.each do |item|
        expected_count *= item.to_a.size
      end
      subject.expand(*list).size.should == expected_count
    end
  end
end
