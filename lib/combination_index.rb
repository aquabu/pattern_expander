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
    array_indexes = []

    _element_list_sizes.reverse.reduce(i) do |i_memo, list_size|
      i_memo, remainder = i_memo.divmod(list_size)
      array_indexes << remainder
      i_memo
    end

    array_indexes.reverse
  end

  def _element_list_sizes
    element_lists.map(&:size)
  end
end
