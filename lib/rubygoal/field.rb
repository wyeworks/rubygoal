require 'forwardable'
require 'gosu'

require 'rubygoal/ball'
require 'rubygoal/coach_loader'
require 'rubygoal/teams/home'
require 'rubygoal/teams/away'
require 'rubygoal/match'
require 'rubygoal/coaches/coach_home'
require 'rubygoal/coaches/coach_away'

module Rubygoal
  class Field
    attr_reader :ball, :team_home, :team_away

    extend Forwardable
    def_delegators :ball, :goal?

    @width                  = 1394
    @height                 = 938
    @offset                 = Position.new(262, 112)
    @goal_height            = 275
    @close_to_goal_distance = 275

    class << self

      attr_reader :width, :height, :offset,
                  :goal_height, :close_to_goal_distance

      def center_position
        center = Position.new(
          width / 2,
          height / 2
        )
        offset.add(center)
      end

      def goal_position(side)
        position = center_position
        case side
        when :home
          position.x = offset.x
        when :away
          position.x = offset.x + width
        end
        position
      end

      def absolute_position(field_position, side)
        case side
        when :home
          offset.add(field_position)
        when :away
          offset.add(
            Position.new(
              width - field_position.x,
              height - field_position.y
            )
          )
        end
      end

      def position_side(position)
        position.x < center_position.x ? :home : :away
      end

      def out_of_bounds_width?(position)
        lower_limit = offset.x
        upper_limit = offset.x + width
        !(lower_limit..upper_limit).include?(position.x)
      end

      def out_of_bounds_height?(position)
        lower_limit = offset.y
        upper_limit = offset.y + height
        !(lower_limit..upper_limit).include?(position.y)
      end

      def goal?(position)
        if out_of_bounds_width?(position)
          lower_limit = center_position.y - goal_height / 2
          upper_limit = center_position.y + goal_height / 2

          (lower_limit..upper_limit).include?(position.y)
        else
          false
        end
      end

      def close_to_goal?(position, side)
        goal_position = Field.goal_position(side)
        goal_position.distance(position) < close_to_goal_distance
      end
    end

    def initialize(game_window, coach_home, coach_away)
      @game_window = game_window

      image_path = File.dirname(__FILE__) + '/../../media/background.png'
      @background_image = Gosu::Image.new(game_window, image_path, true)

      @ball = Ball.new(game_window, Field.center_position)

      @team_home = HomeTeam.new(game_window, coach_home)
      @team_away = AwayTeam.new(game_window, coach_away)
    end

    def reinitialize
      team_home.players_to_initial_position
      team_away.players_to_initial_position
      ball.position = Field.center_position
    end

    def update
      team_home.update(game_data(:home))
      team_away.update(game_data(:away))
      ball.update
    end

    def draw
      background_image.draw(0, 0, 0);
      ball.draw
      team_home.draw
      team_away.draw
    end

    private

    def game_data(side)
      case side
      when :home
        Match.new(
          game_window.score_home,
          game_window.score_away,
          game_window.time,
          team_away.formation
        )
      when :away
        Match.new(
          game_window.score_away,
          game_window.score_home,
          game_window.time,
          team_home.formation
        )
      end
    end

    attr_reader :background_image, :game_window
  end
end
