class CombinationIndex
  attr_reader :element_lists

  def initialize(element_lists)
    @element_lists = element_lists
  end

  def [](i)
    element_list_indexes = _multi_array_indexes(i,element_lists.map(&:size))
    combination = ""
    element_lists.each_with_index do |element_list, index|
      combination += element_list[element_list_indexes[index]]
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
