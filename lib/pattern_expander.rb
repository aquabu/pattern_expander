class PatternExpander
  attr_reader :parser

  def initialize(parser = PatternParser.new)
    @parser = parser
  end

  def get_combinations_by_range(pattern, range)
    range.collect {|i| get_combination_by_index(pattern, i) }
  end

  def get_combination_by_index(pattern, i)
    combination_index = CombinationIndex.new(parser.parse(pattern))
    combination_index[i]
  end
end
