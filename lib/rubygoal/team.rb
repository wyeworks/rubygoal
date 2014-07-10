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
      @players = {}
      @coach = coach

      initialize_lineup_values
      initialize_players(game_window)
      initialize_formation
    end

    def players_to_initial_position
      initial_positions = Team.initial_player_positions

      players.values.each_with_index do |player, index|
        field_position = initial_positions[index]
        player.position = Field.absolute_position(field_position, side)
      end
    end

    def update(match)
      self.formation = coach.formation(match)
      update_positions(formation)

      player_to_move = nil
      min_distance_to_ball = INFINITE
      players.values.each do |player|
        pass_or_shoot(player) if player.can_kick?(game.ball)

        distance_to_ball = player.distance(game.ball.position)
        if min_distance_to_ball > distance_to_ball
          min_distance_to_ball = distance_to_ball
          player_to_move = player
        end
      end

      player_to_move.move_to(game.ball.position)

      players.each do |name, player|
        if player != player_to_move
          unless positions[name]
            puts positions.keys.inspect
            raise "Undefined position for #{name}"
          end
          player.move_to positions[name]
        end
        player.update
      end
    end

    def draw
      players.values.each &:draw
    end

    def formation_for_opponent
      f = Formation.new
      formation.lineup.each_with_index do |line, i|
        line.each_with_index do |name, j|
          if name != :none
            case players[name]
            when CaptainPlayer
              f.lineup[i][j] = :captain
            when FastPlayer
              f.lineup[i][j] = :fast
            when AveragePlayer
              f.lineup[i][j] = :average
            end
          end
        end
      end
      f
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
      average_players = @coach.players[:average]
      fast_players = @coach.players[:fast]
      captain_players = @coach.players[:captain]
      @formation = Formation.new
      @formation.lineup = [
        [average_players[0], :none, average_players[1], :none, :none              ],
        [average_players[2], :none, fast_players[0],    :none, captain_players[0] ],
        [:none,              :none, :none,              :none, :none              ],
        [average_players[3], :none, fast_players[1],    :none, fast_players[2]    ],
        [average_players[4], :none, average_players[5], :none, :none              ]
      ]
    end

    def initialize_players(game_window)
      @players = {goalkeeper: GoalKeeperPlayer.new(game_window, side)}

      unless @coach.valid_formation?
        puts @coach.formation_errors
        raise "Invalid formation: #{@coach.name}"
      end

      @players[@coach.players[:captain].first] = CaptainPlayer.new(game_window, side)
      @coach.players[:fast].each do |name|
        @players[name] = FastPlayer.new(game_window, side)
      end
      @coach.players[:average].each do |name|
        @players[name] = AveragePlayer.new(game_window, side)
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

      (players.values - [player]).each do |teammate|
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

    def update_positions(formation)
      lineup = formation.lineup
      if lineup.flatten.uniq.size != 11
        raise 'Incorrect number of players, are you missing a name?'
      end
      field_goalkeeper_pos = Team.initial_player_positions.first
      goalkeeper_position = Field.absolute_position(field_goalkeeper_pos, side)

      self.positions = {
        goalkeeper: goalkeeper_position
      }

      lineup.each_with_index do |row, y|
        row.each_with_index do |player_name, x|
          self.positions[player_name] = lineup_to_position(x, y) if player_name != :none
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
