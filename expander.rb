class Expander
  attr_reader :results
  WILDCARD = ('a'..'c').to_a #eventually will be a..z + 0..9
  def initialize(patterns)
    @patterns = patterns
  end

  def results
    return WILDCARD if @patterns.size == 1
    return self.class.combine(WILDCARD, WILDCARD)
  end

  def self.expand(xs, ys, *tail)
    result = combine(xs,ys)
    if tail == []
      result
    else
      combine(result, *tail)
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
