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
