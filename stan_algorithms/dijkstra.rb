class Edge
  attr_accessor :src, :dst, :length
  
  def initialize(src, dst, length = 1)
    @src = src
    @dst = dst
    @length = length
  end
end

class Graph < Array
  attr_reader :edges
  
  def initialize
    @edges = []
  end
  
  def connect(src, dst, length = 1)
    unless self.include?(src)
      raise ArgumentException, "No such vertex: #{src}"
    end
    unless self.include?(dst)
      raise ArgumentException, "No such vertex: #{dst}"
    end
    @edges.push Edge.new(src, dst, length)
  end
  
  def connect_mutually(vertex1, vertex2, length = 1)
    self.connect vertex1, vertex2, length
    self.connect vertex2, vertex1, length
  end
  
  def neighbors(vertex)
    neighbors = []
    @edges.each do |edge|
      neighbors.push edge.dst if edge.src == vertex
    end
    return neighbors.uniq
  end
  
  def length_between(src, dst)
    @edges.each do |edge|
      return edge.length if edge.src == src and edge.dst == dst
    end
    nil
  end
  
  def dijkstra(src, dst = nil)
    distances = {}
    previouses = {}
    self.each do |vertex|
      distances[vertex] = nil # Infinity
      previouses[vertex] = nil
    end
    distances[src] = 0
    vertices = self.clone
    until vertices.empty?
      nearest_vertex = vertices.inject do |a, b|
        next b unless distances[a]
        next a unless distances[b]
        next a if distances[a] < distances[b]
        b
      end
      break unless distances[nearest_vertex]
      if dst and nearest_vertex == dst
        return distances[dst]
      end
      neighbors = vertices.neighbors(nearest_vertex)
      neighbors.each do |vertex|
        alt = distances[nearest_vertex] + vertices.length_between(nearest_vertex, vertex)
        if distances[vertex].nil? or alt < distances[vertex]
          distances[vertex] = alt
          previouses[vertices] = nearest_vertex
        end
      end
      vertices.delete nearest_vertex
    end
    if dst
      return nil
    else
      return distances
    end
  end
end

=begin
graph = Graph.new
(1..8).each {|node| graph.push node }
graph.connect 1, 2, 1
graph.connect 1, 8, 2
graph.connect 2, 1, 1
graph.connect 2, 3, 1
graph.connect 3, 2, 1
graph.connect 3, 4, 1
graph.connect 4, 3, 1
graph.connect 4, 5, 1
graph.connect 5, 4, 1
graph.connect 5, 6, 1
graph.connect 6, 5, 1
graph.connect 6, 7, 1
graph.connect 7, 6, 1
graph.connect 7, 8, 1
graph.connect 8, 7, 1
graph.connect 8, 1, 2
puts "1 to 1: #{graph.dijkstra(1, 1)}"
puts "1 to 2: #{graph.dijkstra(1, 2)}"
puts "1 to 3: #{graph.dijkstra(1, 3)}"
puts "1 to 4: #{graph.dijkstra(1, 4)}"
puts "1 to 5: #{graph.dijkstra(1, 5)}"
puts "1 to 6: #{graph.dijkstra(1, 6)}"
puts "1 to 7: #{graph.dijkstra(1, 7)}"
puts "1 to 8: #{graph.dijkstra(1, 8)}"



puts "This is the graph: #{graph}"
puts "This is the length between two and one: #{graph.length_between(1, 2)}"
=end

# Read in data to connect nodes on graph:
hash = Hash.new
array = []
# int_array = []
File.open("dijkstra_graph.txt", "r").each_line do |line|
  array.push line.chop.split(%r{\s+})
end
# Build hash with vertices as keys from the array
array.each do |sub|
  unless sub.empty? # Avoid reading in empty lines
    hash[sub[0].to_i] = []
    sub[1...(sub.length)].each do |string|
      value = []
      temp = string.split(",")
      temp.each do |e|
        value.push e.to_i
        hash[sub[0].to_i].push value
        hash[sub[0].to_i].uniq!
      end
    end
  end
end

puts hash.inspect
graph = Graph.new
(1..200).each {|node| graph.push node }
hash.keys.each do |v|
  hash[v].each do |element|
    dest = element[0]
    length = element[1]
    graph.connect v, dest, length
  end
end

puts "Distance to 7:#{graph.dijkstra(1, 7)}"
puts "Distance to 37:#{graph.dijkstra(1, 37)}"
puts "Distance to 59:#{graph.dijkstra(1, 59)}"
puts "Distance to 82:#{graph.dijkstra(1, 82)}"
puts "Distance to 99:#{graph.dijkstra(1, 99)}"
puts "Distance to 115:#{graph.dijkstra(1, 115)}"
puts "Distance to 133:#{graph.dijkstra(1, 133)}"
puts "Distance to 165:#{graph.dijkstra(1, 165)}"
puts "Distance to 188:#{graph.dijkstra(1, 188)}"
puts "Distance to 197:#{graph.dijkstra(1, 197)}"
