require 'forwardable'

require 'rubygoal/formation'
require 'rubygoal/field'
require 'rubygoal/player'

module Rubygoal
  class Team
    attr_reader :players, :side, :opponent_side, :coach, :formation
    attr_accessor :goalkeeper, :positions

    INFINITE = 100_000

    extend Forwardable
    def_delegators :coach, :name
    def_delegators :game, :ball

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

    def initialize(game, coach)
      @game    = game
      @players = {}
      @coach   = coach

      initialize_lineup_values
      initialize_players
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

      unless formation.valid?
        puts formation.errors
        raise "Invalid formation: #{coach.name}"
      end

      update_positions(formation)

      player_to_move = nil
      min_distance_to_ball = INFINITE
      players.values.each do |player|
        pass_or_shoot(player) if player.can_kick?(ball)

        distance_to_ball = player.distance(ball.position)
        if min_distance_to_ball > distance_to_ball
          min_distance_to_ball = distance_to_ball
          player_to_move = player
        end
      end

      player_to_move.move_to(ball.position)

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

    def players_list
      players.values
    end

    def players_position
      players.each_with_object({}) do |(name, player), hash|
        next if name == :goalkeeper
        hash[name] = Field.field_position(player.position, side)
      end
    end

    private

    attr_reader :game
    attr_writer :formation


    def initialize_lineup_values
      @average_players_count = 6
      @fast_players_count = 3
    end

    def initialize_formation
      @formation = @coach.initial_formation
    end

    def initialize_players
      @players = { goalkeeper: GoalKeeperPlayer.new(game, side) }

      unless @coach.valid?
        puts @coach.errors
        raise "Invalid team definition: #{@coach.name}"
      end

      @players[@coach.captain_player.name] = CaptainPlayer.new(game, side)

      @coach.players_by_type(:fast).each do |player_def|
        @players[player_def.name] = FastPlayer.new(game, side)
      end

      @coach.players_by_type(:average).each do |player_def|
        @players[player_def.name] = AveragePlayer.new(game, side)
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

      player.kick(ball, target)
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
      limit = Field::GOAL_HEIGHT / 2
      offset = Random.rand(-limit..limit)

      target = Field.goal_position(opponent_side)
      target.y += offset
      target
    end

    def update_positions(formation)
      field_goalkeeper_pos = Team.initial_player_positions.first
      goalkeeper_position = Field.absolute_position(field_goalkeeper_pos, side)

      self.positions = {
        goalkeeper: goalkeeper_position
      }

      formation.players_position.each do |player_name, pos|
        self.positions[player_name] = lineup_to_position(pos)
      end
    end

    def lineup_to_position(field_position)
      Field.absolute_position(field_position, side)
    end
  end
end
