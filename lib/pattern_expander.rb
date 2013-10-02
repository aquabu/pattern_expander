class PatternExpander
  attr_reader :combination_index

  def initialize(pattern, substitutes: nil, parser_class: PatternParser)

    unless substitutes.nil?
      parser = parser_class.new(substitutes: substitutes)
    else
      parser = parser_class.new
    end
    @combination_index = CombinationIndex.new(parser.parse(pattern))
  end

  def [](index_or_range)
     combination_index[index_or_range]
  end

  def sample(quantity=1)
    combination_index.sample(quantity)
  end
end
