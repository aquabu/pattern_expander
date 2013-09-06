require_relative '../spec_helper'

describe PatternParser do
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

  describe '.parse' do
    it 'converts patterns into arrays' do
      subject.parse('[a|b|c][1|2|3]').should == [['a','b','c'], ['1','2','3']]
    end
  end
end
