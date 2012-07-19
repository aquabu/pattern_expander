module Expander
  attr_reader :results

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
