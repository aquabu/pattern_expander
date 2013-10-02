require_relative '../spec_helper'

describe PatternExpander do
  describe '#initialize' do
    it 'can take substitutes' do
      pattern_expander = PatternExpander.new(
        '[+x]',
       substitutes: {'+x' => ['did_it']}
      )
      pattern_expander[0].should == 'did_it'
    end
  end

  describe '#[index]' do
    let(:pattern_expander) { PatternExpander.new('[a|b|][1|2]') }

    it 'takes an integer and references the required array values' do
      pattern_expander = PatternExpander.new('[a|b|][1|2]')
      pattern_expander[0].should == 'a1'
      pattern_expander[1].should == 'a2'
      pattern_expander[2].should == 'b1'
      pattern_expander[3].should == 'b2'
    end

    it 'can use single values in expansions' do
        pattern_expander = PatternExpander.new('[foo|biz|bang|bar][_][+d]')
        pattern_expander[9..11].should == ["foo_9", "biz_0", "biz_1"]
    end

    it 'can reference character substitutions' do
      pattern_expander = PatternExpander.new('[+d][+d]')
      pattern_expander[11].should == "11"
    end
  end

  describe '#[i..j] range selector' do
    it 'should take a pattern and a range and return patterns for that range' do
      pattern_expander = PatternExpander.new('[a|b|][1|2]')
      pattern_expander[0..3].should == ['a1','a2','b1','b2']
    end

    it 'should allow combinations' do
      pattern_expander = PatternExpander.new('[+d][+d]')
      pattern_expander[21..23].should ==
        ['21','22','23']
    end

    it 'handles big patterns' do
      pattern_expander = PatternExpander.new('[+w][+w][+w][+w][+w][+w][+w]')
      pattern_expander[100_000..100_003].should ==
                                        ["aaacff2", "aaacff3", "aaacff4", "aaacff5"]
    end
  end

  describe '#sample' do
    let(:pattern_expander) do
      PatternExpander.new('[+w][+d]')
    end

    it 'should get a random combination' do
      pattern_expander.sample.should =~ /^\w\d$/
    end

    it 'can get any number of random combinations' do
      samples = pattern_expander.sample(4)
      samples.size.should == 4
      samples.each {|s| s.should =~ /^\w\d$/ }
    end
  end
end
