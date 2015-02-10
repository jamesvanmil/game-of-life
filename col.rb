class Game
  DEFAULT_GAME_VALUES = {
    seed_chance_of_living:         0.30,
    seed_size:                     10,
    render_size:                   15,
    remain_alive_lower_threshhold: 2,
    remain_alive_upper_threshhold: 3,
    dead_cell_becomes_alive:       3,
    size_of_neighborhood:          1
  }

  attr_accessor :current_generation
  attr_accessor :next_generation

  def initialize
    @current_generation = generate_seed
    @next_generation = Array.new
    render_generation
  end

  def tick
    compute_next_generation
    compile_generation
    render_generation
  end

  private

  def generate_seed(size = DEFAULT_GAME_VALUES[:seed_size], chance_of_living = DEFAULT_GAME_VALUES[:seed_chance_of_living])
    grid = Array.new
    ((-(size))..size).each do |x|
      ((-(size))..size).each do |y|
        grid << [x,y] if rand < chance_of_living
      end
    end
    grid
  end

  def render_generation(render_size = 15)
    ((-(render_size))..render_size).each do |x|
      ((-(render_size))..render_size).each do |y|
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
      if ( living_neighbors == DEFAULT_GAME_VALUES[:remain_alive_lower_threshhold] or living_neighbors == DEFAULT_GAME_VALUES[:remain_alive_upper_threshhold] )
        @next_generation << coordinate
      end 
    end

    @current_generation.each do |coordinate|
      "caluculate whether dead cell becomes alive"
      neighbor_coordinate_finder(coordinate).each do |coordinate|
        living_neighbors = count_living_neighbors(coordinate) unless is_living?(coordinate)
        if ( living_neighbors == DEFAULT_GAME_VALUES[:dead_cell_becomes_alive] )
          @next_generation << coordinate
        end 
      end
    end
  end

  def neighbor_coordinate_finder(coordinate)
    neighbor_coordinates = Array.new
    x = coordinate[0]
    y = coordinate[1]
    radius = DEFAULT_GAME_VALUES[:size_of_neighborhood]
    ((x-radius)..(x+radius)).each do |i|
      ((y-radius)..(y+radius)).each { |j| neighbor_coordinates << [i,j] }
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
