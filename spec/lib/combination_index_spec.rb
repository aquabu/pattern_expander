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

    it 'can take a range' do
      combination_index[0..2].should == ['a1','a2','b1']
    end
  end

  describe '#_multi_array_indexes' do
    it 'should take an index and an array of index sizes and return an array of indexes' do
      combination_index = CombinationIndex.new([[:a,:b],[:a,:b],[:a,:b]])
      combination_index._multi_array_indexes(0).should == [0,0,0]
      combination_index._multi_array_indexes(1).should == [0,0,1]
      combination_index._multi_array_indexes(2).should == [0,1,0]
      combination_index._multi_array_indexes(3).should == [0,1,1]
      combination_index._multi_array_indexes(4).should == [1,0,0]
    end

    it 'can handle a collection of index sizes of variable length' do
      combination_index = CombinationIndex.new([[:a,:b],[:a,:b],[:a,:b],[:a,:b]])
      combination_index._multi_array_indexes(8).should == [1,0,0,0]
      combination_index._multi_array_indexes(15).should == [1,1,1,1]
    end

    it 'can handle a collection of indexes with different sizes' do
      combination_index = CombinationIndex.new([[:a,:b,:c,:d,:e],[:a,:b,:c]])
      combination_index._multi_array_indexes(0).should == [0,0]
      combination_index._multi_array_indexes(2).should == [0,2]
      combination_index._multi_array_indexes(3).should == [1,0]
      combination_index._multi_array_indexes(14).should == [4,2]
    end

    it 'can handle many indexes of varying sizes' do
      a = [:a]
      combination_index = CombinationIndex.new(
        [a * 6, a * 5, a * 4, a * 3, a * 2]
      )
      combination_index._multi_array_indexes(0).should == [0,0,0,0,0]
      combination_index._multi_array_indexes(719).should == [5,4,3,2,1]
    end
  end

  describe '#sample' do
    it 'should get a random combination' do
      letters = ('a'..'z').to_a + ('0'..'9').to_a
      combination_elements = []
      32.times do
        combination_elements << letters
      end

      combination_index = CombinationIndex.new(combination_elements)

      pattern = /^[a-z0-9]{32}$/

      sample_1 = combination_index.sample
      sample_1.should =~ pattern

      sample_2 = combination_index.sample
      sample_2.should =~ pattern

      # chance of collision 1 in 36**32
      sample_1.should_not == sample_2
    end

    it 'can return an arbitrary number of samples' do
      combination_index.stub(:_sample_one) { 'foo' }
      samples = combination_index.sample(3)
      samples.should == ['foo','foo','foo']
    end
  end

  it '#size should return the total number of combinations' do
      CombinationIndex.new([[:a,:b],[0,1]]).size.should == 4
      CombinationIndex.new([[:a,:b,:c],[0,1]]).size.should == 6
      CombinationIndex.new([[:a,:b,:c],[0,1],[0,1]]).size.should == 12
  end
end
