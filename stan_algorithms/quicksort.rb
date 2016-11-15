class QuickSort
  
  attr_accessor :array
  
  @@comparison_count = 0
  
  def initialize(filename)
    @array = []
    File.foreach(filename) do |line|
      @array << line.chomp.to_i
    end
  end
  
  def self.comparison_count
    return @@comparison_count
  end
  
  def quicksort(array, min=0, max=array.length-1)
    return array if array.length == 1
    
    if min < max
      index = reorder_partition_on_median(array, min, max)
      quicksort(array, min, index-1)
      quicksort(array, index+1, max)
    end
  end

  def reorder_partition(array, left_index, right_index)
    middle_index = (left_index + right_index)/2
    pivot_value = array[middle_index]

    array.swap!(middle_index, right_index)

    less_array_pointer = left_index

    (left_index...right_index).each do |greater_array_pointer|
      if array[greater_array_pointer] <= pivot_value
        array.swap!(greater_array_pointer, less_array_pointer)
        less_array_pointer+=1
      end
    end

    array.swap!(less_array_pointer, right_index)

    return less_array_pointer
  end
  
  
  def reorder_partition_first_pivot(array, left_index, right_index)
    # i equals the pointer to the index where the partitioned element will eventually go,
    # thus array[0]...array[i] will all be less than the partition, whereas array[i + 1]...array[right_index]
    # will all be greater than the partitioned element
    @@comparison_count += (left_index...right_index).size
    lesser_than_pivot = left_index + 1
    
    pivot_value = array[left_index]
    
    # At first, j (greater_than_pivot) is going to be equal to i, that is, i == j == left_index + 1
    # Then you go from left_index + 1 all the way to the right_index, swapping a[j] and a[i] wherever
    # a[j] is less than the pivot_value. Do nothing if a[j] is greater than the pivot.
    (lesser_than_pivot..right_index).each do |greater_than_pivot|
      if array[greater_than_pivot] < pivot_value
        array.swap!(greater_than_pivot, lesser_than_pivot)
        lesser_than_pivot += 1
      end
    end
    
    array.swap!(left_index, (lesser_than_pivot - 1))
    
    return lesser_than_pivot - 1
  end
  
  def reorder_partition_last_pivot(array, left_index, right_index)
    array.swap!(right_index, left_index)
    reorder_partition_first_pivot(array, left_index, right_index)
  end
  
  def reorder_partition_on_median(array, left_index, right_index)
    first = array[left_index]
    last = array[right_index]
    range_size = array[left_index..right_index].size
    range = array[left_index..right_index]
    if range_size % 2 == 0
      middle = range[(range_size / 2) - 1]
    else
      middle = range[range_size / 2]
    end
    
    partition = find_median(first, middle, last)
    puts "First: #{first}, Last: #{last}, Middle: #{middle}"
    puts "ON ARRAY: #{range}"
    puts "Chosen Median: #{partition}"
    
    partition_index = array.index(partition)
    array.swap!(partition_index, left_index)
    reorder_partition_first_pivot(array, left_index, right_index)
  end
  
  def find_median(v1, v2, v3)
    if (v1 > v2 && v1 < v3) || (v1 < v2 && v1 > v3)
      return v1
    elsif (v2 > v1 && v2 < v3) || (v2 < v1 && v2 > v3)
      return v2
    else
      return v3
    end
  end
  
end

class Array
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

q = QuickSort.new('quicksort_mass_array.txt')
puts q.array.inspect
q.quicksort(q.array, 0, (q.array.length - 1))
puts q.array.inspect
puts "Number of comparisons: #{QuickSort.comparison_count}"
