require 'gosu'

require 'rubygoal/gui/goal'
require 'rubygoal/gui/field'

require 'rubygoal/coordinate'
require 'rubygoal/game'

module Rubygoal::Gui
  class Game < Gosu::Window
    def initialize
      super(1920, 1080, true)
      self.caption = "Ruby Goal"

      @game = Rubygoal::Game.new

      @gui_field = Field.new(self, game.field)
      @gui_goal = Goal.new(self)

      default_font_size = 48
      @font = Gosu::Font.new(
        self,
        Gosu.default_font_name,
        default_font_size
      )

      @home_team_label = create_label_image(game.coach_home.name)
      @away_team_label = create_label_image(game.coach_away.name)
    end

    def update
      game.update
    end

    def draw
      gui_field.draw
      draw_scoreboard
      draw_team_labels
      gui_goal.draw if game.goal?
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end

    private

    def create_label_image(name)
      name_characters_limit = 20
      name = truncate_label(name, name_characters_limit)

      font_name    = Gosu.default_font_name
      font_size    = 64
      line_spacing = 1
      label_width  = 669
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

      truncated.join(' ')[0..limit]
    end

    def draw_scoreboard
      time_label_position = Rubygoal::Position.new(870, 68)
      draw_text(time_text, time_label_position, :gray)

      score_home_label_position = Rubygoal::Position.new(1150, 68)
      score_away_label_position = Rubygoal::Position.new(1220, 68)
      draw_text(game.score_home.to_s, score_home_label_position, :white)
      draw_text(game.score_away.to_s, score_away_label_position, :white)
    end

    def draw_team_labels
      home_position = Rubygoal::Position.new(105, 580)
      home_team_label.draw_rot(home_position.x, home_position.y, 1, -90)

      away_position = Rubygoal::Position.new(1815, 580)
      away_team_label.draw_rot(away_position.x, away_position.y, 1, 90)
    end

    def draw_text(text, position, color, size = 1)
      font.draw_rel(text, position.x, position.y, 0.5, 0.5, 1, size, size, color_to_hex(color))
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

    attr_reader :game, :gui_field, :gui_goal
    attr_reader :font, :home_team_label, :away_team_label
  end
end
