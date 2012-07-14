require 'rspec'
require 'expander'
describe Expander do
  let(:wildcard) { ['a','b','c'] }
  it 'should take a pattern and return a results' do
    Expander.new('foo').results.should_not be_nil
  end

  it 'should return alphanumeric matches for a wildcard' do
    Expander.new('*').results.should == wildcard
  end

  it 'should return results for multiple wildcards' do
    Expander.new('**').results.should == ['aa','ab','ac','ba','bb','bc','ca','cb','cc'] 
  end

  # it 'should return results for mix of wildcard and chars' do
  #   Expander.new('foo*').results.should == ['fooa','foob','fooc']
  # end

  describe "#permute" do
    it "permutes two arrays" do 
      Expander.permute([:a,:b], [1,2,3]).should == [ [:a,1],[:a,2],[:a,3], [:b,1], [:b,2], [:b,3] ]
    end
  end
end
