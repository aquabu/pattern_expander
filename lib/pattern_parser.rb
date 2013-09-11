# TODO: refactor to PatternParser, PatternMacro (substitute), Combiner, PatternIndex
class PatternParser
  attr_reader :substitutes, :group_regex, :delimiter

  def initialize(substitutes: {}, group_regex: /\[(.*?)\]/, delimiter: '|')
    @substitutes = substitutes
    @group_regex = group_regex
    @delimiter = delimiter
  end

  def parse(string)
    parsed_groups = parse_groups(string).map do |group|
      group.split(delimiter)
    end
    substitute(parsed_groups)
  end

  def parse_groups(string)
    string.scan(group_regex).flatten
  end

  def substitute(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        memo += substitutes[item] || [item]
      end
    end
  end
end
