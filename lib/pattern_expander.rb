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

  def substitute_and_combine_all_to_s(pattern)
    substitute_and_combine_all(pattern).map(&:join)
  end

  def substitute_and_combine_all(pattern)
    combine_all(*parser.parse(pattern))
  end

  def combine_all(xs, ys, *tail)
    result = combine(xs,ys)
    if tail == []
      result
    else
      combine_all(result, *tail)
    end
  end

  def combine(xs, ys)
    xs.inject([]) do |m, x|
      ys.each do |y|
        m << [x,y].flatten
      end
      m
    end
  end
end
