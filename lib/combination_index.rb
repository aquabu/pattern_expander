class CombinationIndex
  attr_reader :element_lists

  def initialize(element_lists)
    @element_lists = element_lists
  end

  def [](i)
    combination = ""
    element_list_indexes = _multi_array_indexes(i)

    element_lists.each do |element_list|
      element_list_index = element_list_indexes.shift
      combination += element_list[element_list_index]
    end

    combination
  end

  # converts a single index to several indexes
  # ie converts from base ten (index) to a mixed base value
  # with each place (element array) being a new base (size of the element array)
  def _multi_array_indexes(i)
    element_list_sizes_tmp = _element_list_sizes
    array_indexes = []

    while element_list_size = element_list_sizes_tmp.pop
      i, remainder = i.divmod(element_list_size)
      array_indexes.unshift remainder
    end

    array_indexes
  end

  def _element_list_sizes
    element_lists.map(&:size)
  end
end
