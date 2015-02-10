SEED_GENERATION = [ [1,1], [1,2], [1,3], [1,4], [1,5], [1,6] ]

class Game
  attr_accessor :current_generation
  attr_accessor :next_generation

  def initialize(seed)
    @current_generation = seed
    @next_generation = Array.new
    render_generation
  end

  def tick
    compute_next_generation
    compile_generation
    render_generation
  end

  private

  def render_generation
    (-10..10).each do |x|
      (-10..10).each do |y|
        if @current_generation.include?([x,y])
          print "0"
        else
          print "."
        end
      end
      puts ""
    end
  end

  def compile_generation
    @next_generation.uniq!
    @current_generation = @next_generation
    @next_generation = Array.new
  end

  def compute_next_generation
    @current_generation.each do |coordinate|
      "calucate whether living cell remains alive"
      living_neighbors = count_living_neighbors(coordinate)
      if ( living_neighbors == 2 or living_neighbors == 3 )
        @next_generation << coordinate
      end 
    end

    @current_generation.each do |coordinate|
      "caluculate whether dead cell becomes alive"
      neighbor_coordinate_finder(coordinate).each do |coordinate|
        living_neighbors = count_living_neighbors(coordinate) unless is_living?(coordinate)
        if ( living_neighbors == 3 )
          @next_generation << coordinate
        end 
      end
    end
  end

  def neighbor_coordinate_finder(coordinate)
    neighbor_coordinates = Array.new
    x = coordinate[0]
    y = coordinate[1]
    ((x-1)..(x+1)).each do |i|
      ((y-1)..(y+1)).each { |j| neighbor_coordinates << [i,j] }
    end
    neighbor_coordinates.delete([x,y])
    neighbor_coordinates
  end

  def count_living_neighbors(coordinate)
    counter = 0 
    neighbor_coordinate_finder(coordinate).each do |coordinate|
      counter += 1 if is_living?(coordinate)
    end
    counter
  end

  def is_living?(coordinate)
      return true if @current_generation.include?(coordinate)
      false
  end
end
