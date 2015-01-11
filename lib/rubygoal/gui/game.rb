require 'gosu'

require 'rubygoal/gui/goal'
require 'rubygoal/gui/field'
require 'rubygoal/gui/ball'
require 'rubygoal/gui/players'

require 'rubygoal/coordinate'
require 'rubygoal/game'

module Rubygoal::Gui
  class Game < Gosu::Window
    WINDOW_WIDTH  = 1920
    WINDOW_HEIGHT = 1080

    TIME_LABEL_POSITION       = Rubygoal::Position.new(870, 68)
    SCORE_HOME_LABEL_POSITION = Rubygoal::Position.new(1150, 68)
    SCORE_AWAY_LABEL_POSITION = Rubygoal::Position.new(1220, 68)

    TEAM_NAME_HOME_LABEL_POSITION = Rubygoal::Position.new(105, 580)
    TEAM_NAME_AWAY_LABEL_POSITION = Rubygoal::Position.new(1815, 580)

    DEFAULT_FONT_SIZE = 48

    LABEL_IMAGE_FONT_SIZE = 64
    LABEL_IMAGE_WIDTH     = 669

    def initialize(game)
      super(WINDOW_WIDTH, WINDOW_HEIGHT, true)
      self.caption = "Ruby Goal"

      @game = game

      @gui_field = Field.new(self)
      @gui_goal = Goal.new(self)
      @gui_ball = Ball.new(self, game.ball)
      @gui_players = players.map { |p| Players.new(self, p) }

      @font = Gosu::Font.new(
        self,
        Gosu.default_font_name,
        DEFAULT_FONT_SIZE
      )

      @home_team_label = create_label_image(game.coach_home.name)
      @away_team_label = create_label_image(game.coach_away.name)
    end

    def update
      game.update
    end

    def draw
      gui_field.draw
      gui_ball.draw
      gui_players.each(&:draw)

      draw_scoreboard
      draw_team_labels
      gui_goal.draw if game.celebrating_goal?
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end

    private

    def players
      game.players
    end

    def create_label_image(name)
      name_characters_limit = 20
      name = truncate_label(name, name_characters_limit)

      font_name    = Gosu.default_font_name
      font_size    = LABEL_IMAGE_FONT_SIZE
      line_spacing = 1
      label_width  = LABEL_IMAGE_WIDTH
      alignment    = :center

      Gosu::Image.from_text(
        self,
        name,
        font_name,
        font_size,
        line_spacing,
        label_width,
        alignment
      )
    end

    def truncate_label(name, limit)
      words = name.split

      left = limit
      truncated = []
      words.each do |word|
        break unless left > 0

        truncated << word
        left -= word.length + 1
      end

      truncated.join(' ')
    end

    def draw_scoreboard
      draw_text(time_text, TIME_LABEL_POSITION, :gray)
      draw_text(game.score_home.to_s, SCORE_HOME_LABEL_POSITION, :white)
      draw_text(game.score_away.to_s, SCORE_AWAY_LABEL_POSITION, :white)
    end

    def draw_team_labels
      draw_vertical_text(home_team_label, TEAM_NAME_HOME_LABEL_POSITION, :down)
      draw_vertical_text(away_team_label, TEAM_NAME_AWAY_LABEL_POSITION, :up)
    end

    def draw_text(text, position, color, scale = 1)
      horizontal_alignment = 0.5
      vertical_alignment   = 0.5
      z_order              = 1
      horizontal_scale     = scale
      vertical_scale       = scale

      font.draw_rel(
        text,
        position.x,
        position.y,
        horizontal_alignment,
        vertical_alignment,
        z_order,
        horizontal_scale,
        vertical_scale,
        color_to_hex(color)
      )
    end

    def draw_vertical_text(label, position, direction = :down)
      angle = direction == :down ? -90 : 90
      label.draw_rot(position.x, position.y, 1, angle)
    end

    def time_text
      minutes = Integer(game.time) / 60
      seconds = Integer(game.time) % 60
      "%d:%02d" % [minutes, seconds]
    end

    def color_to_hex(color)
      case color
      when :white
        0xffffffff
      when :gray
        0xff6d6e70
      end
    end

    attr_reader :game, :gui_field, :gui_goal,
                :gui_ball, :gui_players,
                :font, :home_team_label, :away_team_label
  end
end
