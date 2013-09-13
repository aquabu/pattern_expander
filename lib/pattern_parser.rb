class PatternParser
  attr_reader :substitutes, :group_regex, :delimiter

  def initialize(substitutes: {}, group_regex: /\[(.*?)\]/, delimiter: '|')
    @substitutes = substitutes
    @group_regex = group_regex
    @delimiter = delimiter
  end

  def parse(string)
    parsed_groups = _parse_groups(string).map do |group|
      group.split(delimiter)
    end
    _substitute(parsed_groups)
  end

  def _parse_groups(string)
    string.scan(group_regex).flatten
  end

  def _substitute(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        memo += substitutes[item] || [item]
      end
    end
  end
end
