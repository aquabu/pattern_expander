class PatternExpander
  attr_reader :combination_index

  def initialize(pattern, parser = PatternParser.new)
    @combination_index = CombinationIndex.new(parser.parse(pattern))
  end

  def [](index_or_range)
     combination_index[index_or_range]
  end

  def sample(quantity=1)
    combination_index.sample(quantity)
  end
end
