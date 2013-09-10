require_relative '../spec_helper'

describe PatternParser do
  let(:subject) { PatternParser.new(substitutes) }

  let(:substitutes) do
    {
      "\\w" => ('a'..'z').to_a + ('0'..'9').to_a,
      "\\d" => ('0'..'9').to_a,
      "\\l" => ('a'..'z').to_a
    }
  end

  let(:wildcard) { ['a'..'z', '0'..'9'].inject([]) {|m,v| m + v.to_a} }

  describe '#parse_groups' do
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

  describe '#parse' do
    it 'converts patterns into arrays' do
      subject.parse('[a|b|c][1|2|3]').should == [['a','b','c'], ['1','2','3']]
    end
  end

  describe '#substitute' do
    it 'substitutes a \\w  with an array of wildcard chars' do
      subject.substitute([['\\w']]).should == [ wildcard ]
    end

    it 'substitutes a \\d with an array of numbers' do
      subject.substitute([['\\d']]).should == [ (0..9).map {|c| c.to_s} ]
    end

    it 'substitutes \\l with an array of letters' do
      subject.substitute([['\\l']]).should == [ ('a'..'z').to_a ]
    end
  end
end
