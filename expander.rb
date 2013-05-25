# TODO: refactor to PatternParser, PatternMacro (substitute), Combiner, PatternIndex
class PatternParser
  def initialize(group_regex=/\[(.*?)\]/, delimiter='|')
    @group_regex = group_regex
    @delimiter = delimiter
  end

  def parse(string)
    parse_groups(string).map do |group|
      group.split(@delimiter)
    end
  end

  def parse_groups(string)
    string.scan(@group_regex).flatten
  end
end

class Combiner
  attr_accessor :character_classes
  def initialize(character_classes, parser = PatternParser.new)
    @character_classes = character_classes
    @parser = parser
  end

  def get_patterns_by_range(pattern, range)
    range.collect {|i| get_pattern_by_index(pattern, i) }
  end

  def get_pattern_by_index(pattern, i)
    combinations = substitute_character_classes(@parser.parse(pattern))
    indexes = index_to_array_indexes(i,combinations.map(&:size))
    result = ""
    combinations.each_with_index do |e, index|
      result += e[indexes[index]]
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
    combine_all(*substitute_character_classes(@parser.parse(pattern)))
  end

  def substitute_character_classes(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        memo += character_classes[item] || [item]
      end
    end
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
