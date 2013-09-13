class PatternExpander
  attr_reader :parser
  def initialize(parser = PatternParser.new)
    @parser = parser
  end

  def get_patterns_by_range(pattern, range)
    range.collect {|i| get_pattern_by_index(pattern, i) }
  end

  def get_pattern_by_index(pattern, i)
    pattern_elements = parser.parse(pattern)
    indexes = index_to_array_indexes(i,pattern_elements.map(&:size))
    result = ""
    pattern_elements.each_with_index do |element, index|
      result += element[indexes[index]]
    end
    result
  end

  def index_to_array_indexes(i, sizes)
    result = []
    sizes.reverse.reduce(i) do |m,base|
      m, z = m.divmod(base)
      result << z
      m
    end
    result.reverse
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
