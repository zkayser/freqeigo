class MergeSort
  
  attr_accessor :array

  INPUT_ARRAY = [4, 80, 70, 23, 9, 60, 68, 27, 66, 78, 12, 40, 52, 53, 44,
                 8, 49, 28, 18, 46, 21, 39, 51, 7, 87, 99, 69, 62, 84, 6, 
                 79, 67, 14, 98, 83, 0, 96, 5, 82, 10, 26, 48, 3, 2, 15, 92, 
                 11, 55, 63, 97, 43, 45, 81, 42, 95, 20, 25, 74, 24, 72, 91, 
                 35, 86, 19, 75, 58, 71, 47, 76, 59, 64, 93, 17, 50, 56, 94, 
                 90, 89, 32, 37, 34, 65, 1, 73, 41, 36, 57, 77, 30, 22, 13, 
                 29, 38, 16, 88, 61, 31, 85, 33, 54]
                 
  def initialize(filename)
    @array = []
    File.foreach(filename) do |line|
      @array << line.chomp.to_i
    end
  end

  def mergesort
    if @array.count <= 1
        # Array of length 1 or less is always sorted
        return @array
    end

    # Apply "Divide & Conquer" strategy

    # 1. Divide
    mid = @array.count / 2
    part_a = mergesort @array.slice(0, mid)
    part_b = mergesort @array.slice(mid, array.count - mid)
    puts part_a.inspect
    puts part_b.inspect
    # 2. Conquer
    @array = []
    offset_a = 0
    offset_b = 0
    while offset_a < part_a.count && offset_b < part_b.count
        a = part_a[offset_a]
        b = part_b[offset_b]

        # Take the smallest of the two, and push it on our array
        if a <= b
            @array << a
            offset_a += 1
        else
            @array << b
            offset_b += 1
        end
    end

    # There is at least one element left in either part_a or part_b (not both)
    while offset_a < part_a.count
        @array << part_a[offset_a]
        offset_a += 1
    end

    while offset_b < part_b.count
        @array << part_b[offset_b]
        offset_b += 1
    end

    return @array
  end
  
  
  def sort_and_count(arr)
	 if arr.length <= 1
		return [0, arr]
	 end

	 mid = arr.length / 2	
	 left_arr = arr[0..(mid - 1)] 
	 right_arr = arr[mid..(arr.length - 1)]
	
	 left_result = sort_and_count(left_arr)
	 right_result = sort_and_count(right_arr)
	 merge_result = merge_and_count(left_result[1], right_result[1])
	 
	 puts [left_result[0] + right_result[0] + merge_result[0], merge_result[1]].inspect

	return [left_result[0] + right_result[0] + merge_result[0],
		merge_result[1]]
  end

  def merge_and_count(left_arr, right_arr)
	  inversions = 0
	  output = []
	  i,j = 0,0
	  while i < left_arr.length and j < right_arr.length
		  if left_arr[i] < right_arr[j]
			  output << left_arr[i]
			  i+=1
		  else
			  output << right_arr[j]
			  j+=1
			  inversions += left_arr.length - i
		  end
	  end

	  if i < left_arr.length
		  output += left_arr[i..(left_arr.length - 1)]
	  else
		  output += right_arr[j..(right_arr.length - 1)]
	  end

	  return [inversions, output]
  end
end

m = MergeSort.new("small_array.txt")

puts "Number of inversions: "
puts m.sort_and_count(m.array)[0]

    
    