module Expander
  def parse_and_expand(pattern)
    expand(*parse(pattern))
  end

  def parse(pattern)
    parse_groups(pattern).map do |group|
      group.split("|")
    end
  end

  def replace(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        if item == "\\w"
          memo += ['a'..'z', 0..9].inject([]) {|m,v| m + v.to_a }
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
