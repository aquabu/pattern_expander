require_relative '../spec_helper'

describe CombinationIndex do
  let(:combination_index) do
    CombinationIndex.new([['a','b'], ['1','2']])
  end

  describe '#[]' do
    it 'takes an integer and references the required array values' do
      combination_index[0].should == 'a1'
      combination_index[1].should == 'a2'
      combination_index[2].should == 'b1'
      combination_index[3].should == 'b2'
    end
  end

  describe '#_multi_array_indexes' do
    it 'should take an index and an array of index sizes and return an array of indexes' do
      combination_index._multi_array_indexes(0,[2,2,2]).should == [0,0,0]
      combination_index._multi_array_indexes(1,[2,2,2]).should == [0,0,1]
      combination_index._multi_array_indexes(2,[2,2,2]).should == [0,1,0]
      combination_index._multi_array_indexes(3,[2,2,2]).should == [0,1,1]
      combination_index._multi_array_indexes(4,[2,2,2]).should == [1,0,0]
    end

    it 'can handle a collection of index sizes of variable length' do
      combination_index._multi_array_indexes(8,[2,2,2,2]).should == [1,0,0,0]
      combination_index._multi_array_indexes(15,[2,2,2,2]).should == [1,1,1,1]
    end

    it 'can handle a collection of indexes with different sizes' do
      combination_index._multi_array_indexes(0,[5,3]).should == [0,0]
      combination_index._multi_array_indexes(2,[5,3]).should == [0,2]
      combination_index._multi_array_indexes(3,[5,3]).should == [1,0]
      combination_index._multi_array_indexes(14,[5,3]).should == [4,2]
    end

    it 'can handle many indexes of varying sizes' do
      combination_index._multi_array_indexes(0,[6,5,4,3,2]).should == [0,0,0,0,0]
      combination_index._multi_array_indexes(719,[6,5,4,3,2]).should == [5,4,3,2,1]
    end
  end
end
