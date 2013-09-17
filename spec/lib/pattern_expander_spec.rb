require_relative '../spec_helper'

describe PatternExpander do
  let(:substitutes) do
    {
      "\\w" => ('a'..'z').to_a + ('0'..'9').to_a,
      "\\d" => ('0'..'9').to_a,
      "\\l" => ('a'..'z').to_a
    }
  end

  let(:wildcard) { ['a'..'z', '0'..'9'].inject([]) {|m,v| m + v.to_a} }

  subject { PatternExpander.new(PatternParser.new(substitutes: substitutes)) }

  describe '#get_combination_by_index' do
    it 'takes an integer and references the required array values' do
      subject.get_combination_by_index('[a|b|][1|2]',0).should == 'a1'
      subject.get_combination_by_index('[a|b|][1|2]',1).should == 'a2'
      subject.get_combination_by_index('[a|b|][1|2]',2).should == 'b1'
      subject.get_combination_by_index('[a|b|][1|2]',3).should == 'b2'
    end

    it 'can reference character substitutions' do
      subject.get_combination_by_index('[\\d][\\d]',11).should == "11"
    end
  end

  describe '#get_combinations_by_range' do
    it 'should take a pattern and a range and return patterns for that range' do
      subject.get_combinations_by_range('[a|b|][1|2]',0..3).should == ['a1','a2','b1','b2']
    end

    it 'should allow combinations' do
      subject.get_combinations_by_range('[\\d][\\d]',21..23).should ==
        ['21','22','23']
    end

    it 'handles big patterns' do
      subject.get_combinations_by_range('[\\w][\\w][\\w][\\w][\\w][\\w][\\w]',
                                        100_000..100_003).should ==
                                        ["aaacff2", "aaacff3", "aaacff4", "aaacff5"]
    end
  end
end
