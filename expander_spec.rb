require 'rspec'
require 'expander'

describe Combiner do
  subject {Class.new {include Combiner}.new }

  let(:wildcard) { ['a'..'z', '0'..'9'].inject([]) {|m,v| m + v.to_a} }

  describe '#map_index_to_array' do
    it 'should take an index and an array of index sizes and return an array of indexes' do
      subject.map_index_to_array(0,[2,2,2]).should == [0,0,0]
      subject.map_index_to_array(1,[2,2,2]).should == [0,0,1]
      subject.map_index_to_array(2,[2,2,2]).should == [0,1,0]
      subject.map_index_to_array(3,[2,2,2]).should == [0,1,1]
      subject.map_index_to_array(4,[2,2,2]).should == [1,0,0]
    end

    it 'can handle a collection of index sizes of variable length' do
      subject.map_index_to_array(8,[2,2,2,2]).should == [1,0,0,0]
      subject.map_index_to_array(15,[2,2,2,2]).should == [1,1,1,1]
    end

    it 'can handle a collection of indexes with different sizes' do
      subject.map_index_to_array(0,[5,3]).should == [0,0]
      subject.map_index_to_array(2,[5,3]).should == [0,2]
      subject.map_index_to_array(3,[5,3]).should == [1,0]
      subject.map_index_to_array(14,[5,3]).should == [4,2]
    end

    it 'can handle many indexes of varying sizes' do
      subject.map_index_to_array(0,[6,5,4,3,2]).should == [0,0,0,0,0]
      subject.map_index_to_array(719,[6,5,4,3,2]).should == [5,4,3,2,1]
    end
  end

  describe '.get_pattern_by_index' do
    it 'takes an integer and references the required array values' do
      subject.get_pattern_by_index('[a|b|][1|2]',0).should == 'a1'
      subject.get_pattern_by_index('[a|b|][1|2]',1).should == 'a2'
      subject.get_pattern_by_index('[a|b|][1|2]',2).should == 'b1'
      subject.get_pattern_by_index('[a|b|][1|2]',3).should == 'b2'
    end

    it 'can reference character substitutions' do
      subject.get_pattern_by_index('[\\d][\\d]',11).should == "11"
    end
  end

  describe '.get_patterns_by_range' do
    it 'should take a pattern and a range and return patterns for that range' do
      subject.get_patterns_by_range('[a|b|][1|2]',0..3).should == ['a1','a2','b1','b2']
    end

    it 'should allow combinations' do
      subject.get_patterns_by_range('[\\d][\\d]',21..23).should == 
        ['21','22','23']
    end

    it 'handles big patterns' do
      subject.get_patterns_by_range('[\\w][\\w][\\w][\\w][\\w][\\w][\\w]',
                                    100_000..100_003).should == 
                                    ["aaacff2", "aaacff3", "aaacff4", "aaacff5"]
    end
  end

  describe '.substitute_and_combine_all' do
    it 'should create combinations of parsed string values' do
      subject.substitute_and_combine_all('[a|b|][1|2]').should == [
        ['a','1'],['a','2'],
        ['b','1'],['b','2']]
    end

    it 'should substitute_character_classes and permute character classes' do
      subject.substitute_and_combine_all('[a][\d]').should == [
        ['a', '0'],
        ['a', '1'],
        ['a', '2'],
        ['a', '3'],
        ['a', '4'],
        ['a', '5'],
        ['a', '6'],
        ['a', '7'],
        ['a', '8'],
        ['a', '9']
      ]
    end
  end

  describe '.substitute_and_combine_all_to_s' do
    it 'returns combinations as strings' do
      subject.substitute_and_combine_all_to_s('[a|b|][1|2]').should == ['a1','a2','b1','b2']
    end
  end

  describe '.parse' do
    it 'converts patterns into arrays' do
      subject.parse('[a|b|c][1|2|3]').should == [['a','b','c'], ['1','2','3']]
    end
  end

  describe '.substitute_character_classes' do
    it 'substitutes a \\w  with an array of wildcard chars' do
      subject.substitute_character_classes([['\\w']]).should == [ wildcard ] 
    end

    it 'substitutes a \\d with an array of numbers' do
      subject.substitute_character_classes([['\\d']]).should == [ (0..9).map {|c| c.to_s} ] 
    end

    it 'substitutes \\l with an array of letters' do
      subject.substitute_character_classes([['\\l']]).should == [ ('a'..'z').to_a ] 
    end
  end
  
  describe '.parse_groups' do
    it 'should handle a single group' do
      subject.parse_groups('[a]').should == ['a']
    end

    it 'should return an array of group string' do
      subject.parse_groups('[a][b][c]').should == ['a','b','c']
    end

    it 'should return on array of group strings including | chars' do
      subject.parse_groups('[a|b][c|d]').should == ['a|b','c|d']
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

  it '.combine_all combines lists of arrays' do
    subject.combine_all([:a,:b],[1,2],[:c,:d]).should == [[:a, 1, :c],
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
        subject.combine_all(*list)
      }.to_not raise_error
    end
    it 'has the expected number of permutations' do
      expected_count = 1 
      list.each do |item|
        expected_count *= item.to_a.size
      end
      subject.combine_all(*list).size.should == expected_count
    end
  end
end
