require_relative '../spec_helper'

describe PatternParser do
  let(:substitutes) do
    {
      "+w" => ('a'..'z').to_a + ('0'..'9').to_a,
      "+d" => ('0'..'9').to_a,
      "+l" => ('a'..'z').to_a
    }
  end

  let(:subject) { PatternParser.new(substitutes: substitutes) }
  let(:wildcard) { ['a'..'z', '0'..'9'].inject([]) {|m,v| m + v.to_a} }

  describe '#_parse_groups' do
    it 'should handle a single group' do
      subject._parse_groups('[a]').should == ['a']
    end

    it 'should return an array of group string' do
      subject._parse_groups('[a][b][c]').should == ['a','b','c']
    end

    it 'should return on array of group strings including | chars' do
      subject._parse_groups('[a|b][c|d]').should == ['a|b','c|d']
    end

    it 'should return non bracket string as their own elements' do
      subject._parse_groups('foo[a]').should == ['foo', 'a']
    end
  end

  describe '#parse' do
    it 'converts patterns into arrays' do
      subject.parse('[a|b|c][1|2|3]').should == [['a','b','c'], ['1','2','3']]
    end

    it 'substitutes patterns in arrays' do
      subject.parse('[+d]').should == [('0'..'9').to_a]
    end

    it 'sustitutes patterns outside of arrays' do
      subject.parse('+d').should == [('0'..'9').to_a]
    end

    it 'leaves non substituted string as ordinary arrays' do
      subject.parse('foo[+d]bar').should == [['foo'],('0'..'9').to_a,['bar']]
    end
  end

  describe '#_substitute' do
    it 'substitutes a +w  with an array of wildcard chars' do
      subject._substitute([['+w']]).should == [ wildcard ]
    end

    it '_substitutes a +d with an array of numbers' do
      subject._substitute([['+d']]).should == [ (0..9).map {|c| c.to_s} ]
    end

    it '_substitutes +l with an array of letters' do
      subject._substitute([['+l']]).should == [ ('a'..'z').to_a ]
    end
  end
end
