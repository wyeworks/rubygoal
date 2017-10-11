require 'forwardable'

require 'rubygoal/formation'
require 'rubygoal/field'
require 'rubygoal/players/average'
require 'rubygoal/players/fast'
require 'rubygoal/players/captain'
require 'rubygoal/players/goalkeeper'
require 'rubygoal/match_data'

module Rubygoal
  class Team
    attr_reader :players, :side, :opponent_side, :coach, :formation
    attr_accessor :goalkeeper

    INFINITE = 100_000

    extend Forwardable
    def_delegators :coach, :name
    def_delegators :game, :ball

    def initialize(game, coach)
      @game    = game
      @players = {}
      @coach   = coach

      @match_data_factory = MatchData::Factory.new(game, side)

      initialize_lineup_values
      initialize_players
      initialize_formation
    end

    def players_to_initial_position
      match_data = match_data_factory.create
      formation = coach.formation(match_data)
      restart_player_positions_in_own_field(formation)
    end

    def update(elapsed_time)
      match_data = match_data_factory.create
      self.formation = coach.formation(match_data)

      unless formation.valid?
        puts formation.errors
        raise "Invalid formation: #{coach.name}"
      end

      update_coach_defined_positions(formation)

      player_to_move = nil
      min_distance_to_ball = INFINITE
      players_list.each do |player|
        pass_or_shoot(player) if player.can_kick?(ball)

        distance_to_ball = player.distance(ball.position)
        if min_distance_to_ball > distance_to_ball
          min_distance_to_ball = distance_to_ball
          player_to_move = player
        end
      end

      player_to_move.move_to(ball.position)

      players.each do |name, player|
        if name == :goalkeeper
          if player != player_to_move
            player.move_to_cover_goal(ball)
            player.update(elapsed_time)
            next
          end
        end

        player.move_to_coach_position unless player == player_to_move
        player.update(elapsed_time)
      end
    end

    def players_list
      players.values
    end

    def players_position
      players.each_with_object({}) do |(name, player), hash|
        hash[name] = Field.field_position(player.position, side)
      end
    end

    private

    attr_reader :game, :match_data_factory
    attr_writer :formation

    def initialize_lineup_values
      @average_players_count = 6
      @fast_players_count = 3
    end

    def initialize_formation
      @formation = @coach.initial_formation
    end

    def initialize_players
      @players = { goalkeeper: GoalKeeperPlayer.new(game, side, :goalkeeper) }

      unless @coach.valid?
        puts @coach.errors
        raise "Invalid team definition: #{@coach.name}"
      end

      @players[@coach.captain_player.name] = CaptainPlayer.new(game, side, @coach.captain_player.name)

      @coach.players_by_type(:fast).each do |player_def|
        @players[player_def.name] = FastPlayer.new(game, side, player_def.name)
      end

      @coach.players_by_type(:average).each do |player_def|
        @players[player_def.name] = AveragePlayer.new(game, side, player_def.name)
      end

      initialize_player_positions
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
        next unless teammate_is_on_front?(player, teammate)
        dist = player.distance(teammate.position)
        if min_dist > dist
          nearest_teammate = teammate
          min_dist = dist
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

    def initialize_player_positions
      Field.default_player_field_positions.each_with_index do |pos, index|
        players.values[index].position = lineup_to_position(pos)
        players.values[index].coach_defined_position = lineup_to_position(pos)
      end
    end

    def update_coach_defined_positions(formation)
      formation.players_position.each do |player_name, pos|
        players[player_name].coach_defined_position = lineup_to_position(pos)
      end
    end

    def restart_player_positions_in_own_field(formation)
      formation.players_position.each do |player_name, pos|
        pos.x *= 0.5
        pos = lineup_to_position(pos)

        player = players[player_name]

        player.coach_defined_position = pos
        player.position = pos
      end
    end

    def lineup_to_position(field_position)
      Field.absolute_position(field_position, side)
    end

    def goalkeeper
      players[:goalkeeper]
    end
  end
end
