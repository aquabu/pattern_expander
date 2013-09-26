require_relative '../spec_helper'

describe PatternExpander do
  let(:substitutes) do
    {
      "+w" => ('a'..'z').to_a + ('0'..'9').to_a,
      "+d" => ('0'..'9').to_a,
    }
  end


  describe '#get_combination_by_index' do
    let(:pattern_expander) { PatternExpander.new('[a|b|][1|2]', PatternParser.new(substitutes: substitutes)) }
    it 'takes an integer and references the required array values' do
      pattern_expander = PatternExpander.new('[a|b|][1|2]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combination_by_index(0).should == 'a1'
      pattern_expander.get_combination_by_index(1).should == 'a2'
      pattern_expander.get_combination_by_index(2).should == 'b1'
      pattern_expander.get_combination_by_index(3).should == 'b2'
    end

    it 'can reference character substitutions' do
      pattern_expander = PatternExpander.new('[+d][+d]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combination_by_index(11).should == "11"
    end
  end

  describe '#get_combinations_by_range' do
    it 'should take a pattern and a range and return patterns for that range' do
      pattern_expander = PatternExpander.new('[a|b|][1|2]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combinations_by_range(0..3).should == ['a1','a2','b1','b2']
    end

    it 'should allow combinations' do
      pattern_expander = PatternExpander.new('[+d][+d]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combinations_by_range(21..23).should ==
        ['21','22','23']
    end

    it 'handles big patterns' do
      pattern_expander = PatternExpander.new('[+w][+w][+w][+w][+w][+w][+w]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combinations_by_range(100_000..100_003).should ==
                                        ["aaacff2", "aaacff3", "aaacff4", "aaacff5"]
    end
  end

  it 'can use single values in expansions' do
      pattern_expander = PatternExpander.new('[foo|biz|bang|bar][_][+d]', PatternParser.new(substitutes: substitutes))
      pattern_expander.get_combinations_by_range(9..11).should == ["foo_9", "biz_0", "biz_1"]
  end
end
