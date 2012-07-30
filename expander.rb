module Expander
  CHARACTER_CLASSES = {
    "\\w" => ('a'..'z').to_a + ('0'..'9').to_a,
    "\\d" => ('0'..'9').to_a,
    "\\l" => ('a'..'z').to_a 
  } 
  def parse_and_expand(pattern)
    expand(*parse(pattern))
  end

  def parse(pattern)
    groups = parse_groups(pattern).map do |group|
      group.split("|")
    end
    substitute(groups)
  end

  def substitute(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        if CHARACTER_CLASSES[item]
          memo += CHARACTER_CLASSES[item]
        else
          memo << item
        end
      end
    end
  end

  def parse_groups(pattern)
    pattern.scan(/\[(.*?)\]/).flatten
  end

  def expand(xs, ys, *tail)
    result = combine(xs,ys)
    if tail == []
      result
    else
      expand(result, *tail)
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
