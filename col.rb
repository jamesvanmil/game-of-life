class Game
  require 'ostruct'
  
  ### Configuration

  DEFAULT_GAME_VALUES = {
    seed_chance_of_living:         0.30,
    seed_size:                     10,
    render_size_x:                 50,
    render_size_y:                 25,
    run_turns:                     100
  }

  CELL_FATE = {
    ## for living cells
    alive: {
      0 => false,
      1 => false,
      2 => true,
      3 => true,
      4 => false,
      5 => false,
      6 => false,
      7 => false,
      8 => false
    },
    ## for dead cells
    dead: {
      0 => false,
      1 => false,
      2 => false,
      3 => true,
      4 => false,
      5 => false,
      6 => false,
      7 => false,
      8 => false
    }
  }
  
  ### Begin class definition

  def initialize
    @cells = Hash.new
    seeds.each { |coordinate| create_cell(coordinate[0], coordinate[1]) }
  end

  def run
    DEFAULT_GAME_VALUES[:run_turns].times { tick }
  end

  def tick
    calculate_all_votes
    delete_cells_that_are_going_to_die
    enliven_cells_that_remain_and_reset_votes
    render_generation
  end

  private

  ### Primary functions

  def seeds
    seeds = Array.new
    ((-DEFAULT_GAME_VALUES[:seed_size])..(DEFAULT_GAME_VALUES[:seed_size])).each do |x|
      ((-DEFAULT_GAME_VALUES[:seed_size])..(DEFAULT_GAME_VALUES[:seed_size])).each do |y|
        seeds << [x, y] if rand < DEFAULT_GAME_VALUES[:seed_chance_of_living]
      end
    end
    seeds
  end

  def calculate_all_votes
    @cells.keys.each { |coordinate| vote_for_neighbors(coordinate[0], coordinate[1]) }
  end

  def delete_cells_that_are_going_to_die
    @cells.keys.each do |coordinate|
      destroy_cell(coordinate[0], coordinate[1]) unless alive_next_turn?(@cells[coordinate])
    end
  end

  def enliven_cells_that_remain_and_reset_votes
    @cells.keys.each do |coordinate|
      @cells[coordinate].status = :alive 
      @cells[coordinate].votes = 0
    end
  end

  def render_generation
    system("clear")
    x = DEFAULT_GAME_VALUES[:render_size_x]
    y = DEFAULT_GAME_VALUES[:render_size_y]
    ((-y)..y).each do |y|
      ((-x)..x).each do |x|
        if @cells.keys.include?([x,y])
          print "0"
        else
          print "."
        end
      end
      puts ""
    end
    sleep 0.1
  end

  ### Secondary functions

  def create_cell(x, y, votes = 0, status: :alive)
    "The hash key keeps track of the coordinates"
    @cells[[x, y]] = OpenStruct.new(votes: votes, status: status)
  end

  def destroy_cell(x, y)
    @cells.delete([x, y])
  end
  
  def alive_next_turn?(cell)
    CELL_FATE[cell.status][cell.votes]
  end

  def vote_for_neighbors(x, y)
    neighbor_coordinates(x, y).each do |coordinate|
      cast_vote(coordinate[0], coordinate[1])
    end
  end

  ### Tertiary functions

  def cast_vote(x, y)
    ## if exists, vote++
    if @cells.keys.include?([x, y])
      @cells[[x, y]].votes += 1
    else
    ## else create dead cell with one vote
      create_cell(x, y, votes = 1, status: :dead)
    end
  end

  def neighbor_coordinates(x, y)
    neighbor_coordinates = Array.new
    ((x-1)..(x+1)).each do |x|
      ((y-1)..(y+1)).each { |y| neighbor_coordinates << [x, y] }
    end
    neighbor_coordinates.delete([x, y])
    neighbor_coordinates
  end
end
