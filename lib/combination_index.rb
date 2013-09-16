class CombinationIndex
  attr_reader :element_arrays

  def initialize(element_arrays)
    @element_arrays = element_arrays
  end

  def [](i)
    indexes = _index_to_array_indexes(i,element_arrays.map(&:size))
    result = ""
    element_arrays.each_with_index do |element, index|
      result += element[indexes[index]]
    end
    result
  end

  def _index_to_array_indexes(i, sizes)
    result = []
    sizes.reverse.reduce(i) do |m,base|
      m, z = m.divmod(base)
      result << z
      m
    end
    result.reverse
  end
end
