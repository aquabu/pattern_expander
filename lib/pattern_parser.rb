class PatternParser
  attr_reader :substitutes, :delimiter

  DEFAULT_SUBSTITUTES = {
    "+w" => ('a'..'z').to_a + ('0'..'9').to_a,
    "+d" => ('0'..'9').to_a,
  }

  def initialize(substitutes: DEFAULT_SUBSTITUTES)
    @substitutes = substitutes
    @delimiter = '|'
  end

  def parse(string)
    parsed_groups = _parse_groups(string).map do |group|
      group.split(delimiter)
    end
    _substitute(parsed_groups)
  end

  def _parse_groups(string)
    string.scan(
      /([^\[\]]+|[\#{delimiter}]+)/
    ).flatten
  end

  def _substitute(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        memo += substitutes[item] || [item]
      end
    end
  end
end
