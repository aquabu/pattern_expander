class CombinationIndex
  attr_reader :element_arrays

  def initialize(element_arrays)
    @element_arrays = element_arrays
  end

  def [](i)
    indexes = _multi_array_indexes(i,element_arrays.map(&:size))
    combination = ""
    element_arrays.each_with_index do |element, index|
      combination += element[indexes[index]]
    end
    combination
  end

  # converts a single index to several indexes
  # ie converts from base ten (index) to a mixed base value
  # with each place (element array) being a new base (size of the element array)
  def _multi_array_indexes(i, sizes)
    array_indexes = []
    sizes.reverse.reduce(i) do |carried_index, base|
      carried_index, remainder = carried_index.divmod(base)
      array_indexes << remainder
      carried_index
    end
    array_indexes.reverse
  end
end
