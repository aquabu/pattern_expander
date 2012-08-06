module Expander
  CHARACTER_CLASSES = {
    "\\w" => ('a'..'z').to_a + ('0'..'9').to_a,
    "\\d" => ('0'..'9').to_a,
    "\\l" => ('a'..'z').to_a 
  } 

  class Index
    def map_index_to_array(i, sizes)
      # x,y = index.divmod(sizes.last)
      # [0,x,y]
      # indexes = []
      # sizes.reverse.each do
      #   x,y = index.divmod(size)
      # end
        # m, z = m.divmod(2) 
        # m, y = m.divmod(2) 
        # m, x = m.divmod(2)
      result = []
      sizes.reverse.reduce(i) do |m,base|
        m, z = m.divmod(base) 
        result << z 
        m
      end
      result.reverse
    end
  end



  def index(i)
    x = i
    y = i #obviously wrong
    ['a','b'][x] + ['1','2'][y]
  end

  def expand_strings(pattern)
    expand(pattern).map(&:join)
  end

  def expand(pattern)
    combine_all(*substitute_character_classes(parse(pattern)))
  end

  def parse(pattern)
    parse_groups(pattern).map do |group|
      group.split("|")
    end
  end

  def parse_groups(pattern)
    pattern.scan(/\[(.*?)\]/).flatten
  end

  def substitute_character_classes(groups)
    groups.map do |group|
      group.inject([]) do |memo, item|
        memo += CHARACTER_CLASSES[item] || [item]
      end
    end
  end

  def combine_all(xs, ys, *tail)
    result = combine(xs,ys)
    if tail == []
      result
    else
      combine_all(result, *tail)
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
