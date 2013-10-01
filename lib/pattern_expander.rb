class PatternExpander
  attr_reader :combination_index

  def initialize(pattern, parser = PatternParser.new)
    @combination_index = CombinationIndex.new(parser.parse(pattern))
  end

  def get_combinations_by_range(range)
    range.collect {|i| get_combination_by_index(i) }
  end

  def get_combination_by_index(i)
    combination_index[i]
  end

  def sample(quantity=1)
    combination_index.sample(quantity)
  end
end
