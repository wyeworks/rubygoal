require 'forwardable'

require 'rubygoal/formation'
require 'rubygoal/field'
require 'rubygoal/player'

module Rubygoal
  class Team
    attr_reader :game, :players, :side, :opponent_side, :coach, :formation
    attr_accessor :goalkeeper, :positions

    INFINITE = 100_000

    extend Forwardable
    def_delegators :coach, :name

    def self.initial_player_positions
      [
        Position.new(50, 469),
        Position.new(236, 106),
        Position.new(236, 286),
        Position.new(236, 646),
        Position.new(236, 826),
        Position.new(436, 106),
        Position.new(436, 286),
        Position.new(436, 646),
        Position.new(436, 826),
        Position.new(616, 436),
        Position.new(616, 496)
      ]
    end

    def self.goalkeeper_position
      initial_player_positions.first
    end

    def initialize(game_window, coach)
      @game = game_window
      @players = []
      @coach = coach

      initialize_lineup_values
      initialize_formation
      initialize_players(game_window)
    end

    def players_to_initial_position
      initial_positions = Team.initial_player_positions

      players.each_with_index do |player, index|
        field_position = initial_positions[index]
        player.position = Field.absolute_position(field_position, side)
      end
    end

    def update(match)
      self.formation = coach.formation(match)
      unless formation.valid?
        puts formation.errors
        raise "Invalid formation: #{coach.name}"
      end
      update_positions(formation.lineup)

      player_to_move = nil
      min_distance_to_ball = INFINITE
      players.each do |player|
        pass_or_shoot(player) if player.can_kick?(game.ball)

        distance_to_ball = player.distance(game.ball.position)
        if min_distance_to_ball > distance_to_ball
          min_distance_to_ball = distance_to_ball
          player_to_move = player
        end
      end

      player_to_move.move_to(game.ball.position)

      average_players = []
      fast_players = []
      captain_player = nil

      players.each do |player|
        if player.is_a? AveragePlayer
          average_players << player
        elsif player.is_a? FastPlayer
          fast_players << player
        else
          captain_player = player
        end
      end

      if captain_player != player_to_move
        captain_player.move_to(positions[:captain])
      end
      captain_player.update

      average_players.each_with_index do |player, index|
        if player != player_to_move
          player.move_to(positions[:average][index])
        end

        player.update
      end

      fast_players.each_with_index do |player, index|
        if player != player_to_move
          player.move_to(positions[:fast][index])
        end

        player.update
      end
    end

    def draw
      players.each(&:draw)
    end

    private

    attr_reader :lineup_step_x, :lineup_step_y, :lineup_offset_x
    attr_writer :formation


    def initialize_lineup_values
      @lineup_offset_x = 30
      @lineup_step_x = Field.width / 6
      @lineup_step_y = Field.height / 6

      @average_players_count = 6
      @fast_players_count = 3
    end

    def initialize_formation
      @formation = Formation.new
      @formation.lineup = [
        [:average, :none, :average, :none, :none   ],
        [:average, :none, :fast,    :none, :captain],
        [:none,    :none, :none,    :none, :none   ],
        [:average, :none, :fast,    :none, :fast   ],
        [:average, :none, :average, :none, :none   ]
      ]
    end

    def initialize_players(game_window)
      players << GoalKeeperPlayer.new(game_window, side)

      config = Rubygoal.configuration

      config.average_players_count.times do
        players << AveragePlayer.new(game_window, side)
      end
      config.fast_players_count.times do
        players << FastPlayer.new(game_window, side)
      end
      config.captain_players_count.times do
        players << CaptainPlayer.new(game_window, side)
      end

      players_to_initial_position
    end

    def pass_or_shoot(player)
      # Kick straight to the goal whether the distance is short (200)
      # or we don't have a better option
      target = shoot_target

      unless Field.close_to_goal?(player.position, opponent_side)
        if teammate = nearest_forward_teammate(player)
          target = teammate.position
        end
      end

      player.kick(game.ball, target)
    end

    def nearest_forward_teammate(player)
      min_dist = INFINITE
      nearest_teammate = nil

      (players - [player]).each do |teammate|
        if teammate_is_on_front?(player, teammate)
          dist = player.distance(teammate.position)
          if min_dist > dist
            nearest_teammate = teammate
            min_dist = dist
          end
        end
      end

      nearest_teammate
    end

    def shoot_target
      # Do not kick always to the center, look for the sides of the goal
      limit = Field.goal_height / 2
      offset = Random.rand(-limit..limit)

      target = Field.goal_position(opponent_side)
      target.y += offset
      target
    end

    def update_positions(lineup)
      field_goalkeeper_pos = Team.initial_player_positions.first
      goalkeeper_position = Field.absolute_position(field_goalkeeper_pos, side)

      self.positions = {
        average: [goalkeeper_position],
        fast: []
      }

      lineup.each_with_index do |row, y|
        row.each_with_index do |player_type, x|
          case player_type
          when :average, :fast
            positions[player_type] << lineup_to_position(x, y)
          when :captain
            positions[:captain] = lineup_to_position(x, y)
          end
        end
      end
    end

    def lineup_to_position(x, y)
      field_position = Position.new(
        (x + 1) * lineup_step_x - lineup_offset_x,
        (y + 1) * lineup_step_y
      )
      Field.absolute_position(field_position, side)
    end
  end
end
