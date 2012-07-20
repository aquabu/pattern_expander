module Expander
  attr_reader :results
  def self.parse(pattern)
    parse_groups(pattern).map do |group|
      group.split("|")
    end
  end

  def self.parse_groups(pattern)
    pattern.scan(/\[(.*?)\]/).flatten
  end

  def self.expand(xs, ys, *tail)
    result = combine(xs,ys)
    if tail == []
      result
    else
      expand(result, *tail)
    end
  end

  def self.combine(xs, ys)
    xs.inject([]) do |m, x|
      ys.each do |y|
        m << [x,y].flatten
      end
      m
    end
  end
end
