class Expander
  attr_reader :results
  WILDCARD = ('a'..'c').to_a #eventually will be a..z + 0..9
  def initialize(pattern)
    @pattern = pattern.split ''
  end

  def results
    if @pattern.size == 1
      WILDCARD
    else
      ['aa','ab','ac','ba','bb','bc','ca','cb','cc'] 
    end
  end

  def self.permute(xs, ys)
    xs.inject([]) do |m, x|
      ys.each do |y|
        m << [x,y] 
      end
      m
    end
  end

  def expand(head, *tail)
  end
end
