require 'gosu'
require 'forwardable'

require 'rubygoal/coordinate'
require 'rubygoal/field'
require 'rubygoal/goal'

module Rubygoal
  class Game < Gosu::Window
    attr_reader :field, :time,
                :coach_home, :coach_away,
                :score_home, :score_away

    extend Forwardable
    def_delegators :field, :ball, :close_to_goal?

    def initialize
      super(1920, 1080, true)
      self.caption = "Ruby Goal"

      initialize_coaches

      @field = Field.new(self, coach_home, coach_away)
      @goal = Goal.new(self)

      @state = :playing

      @time = Rubygoal.configuration.game_time
      @score_home = 0
      @score_away = 0

      default_font_size = 48
      @font = Gosu::Font.new(
        self,
        Gosu.default_font_name,
        default_font_size
      )

      @home_team_label = create_label_image(coach_home.name)
      @away_team_label = create_label_image(coach_away.name)
    end

    def update
      return if state == :ended

      update_elapsed_time

      if field.goal?
        update_goal
      else
        update_remaining_time
        field.update
      end

      end_match! if time <= 0
    end

    def draw
      field.draw
      draw_scoreboard
      draw_team_labels
      goal.draw if field.goal?
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end

    protected

    attr_writer :time, :score_home, :score_away
    attr_accessor :state, :last_time, :elapsed_time

    private

    attr_reader :font, :goal, :home_team_label, :away_team_label

    def initialize_coaches
      @coach_home = CoachLoader.get(CoachHome)
      @coach_away = CoachLoader.get(CoachAway)

      puts "Home coach: #{@coach_home.name}"
      puts "Away coach: #{@coach_away.name}"
    end

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

    def update_elapsed_time
      self.last_time ||= Time.now

      self.elapsed_time = Time.now - last_time
      self.last_time = Time.now
    end

    def update_remaining_time
      self.time -= elapsed_time
    end

    def update_goal
      goal.update(elapsed_time)
      reinitialize_match if goal.celebration_done?
    end

    def reinitialize_match
      if Field.position_side(ball.position) == :home
        self.score_away += 1
      else
        self.score_home += 1
      end

      field.reinitialize
    end

    def draw_scoreboard
      time_label_position = Position.new(870, 68)
      draw_text(time_text, time_label_position, :gray)

      score_home_label_position = Position.new(1150, 68)
      score_away_label_position = Position.new(1220, 68)
      draw_text(score_home.to_s, score_home_label_position, :white)
      draw_text(score_away.to_s, score_away_label_position, :white)
    end

    def draw_team_labels
      home_position = Position.new(105, 580)
      home_team_label.draw_rot(home_position.x, home_position.y, 1, -90)

      away_position = Position.new(1815, 580)
      away_team_label.draw_rot(away_position.x, away_position.y, 1, 90)
    end

    def draw_text(text, position, color, size = 1)
      font.draw_rel(text, position.x, position.y, 0.5, 0.5, 1, size, size, color_to_hex(color))
    end

    def time_text
      minutes = Integer(time) / 60
      seconds = Integer(time) % 60
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

    def end_match!
      self.state = :ended
      write_score
    end

    def write_score
      puts "#{coach_home.name} #{score_home} - #{score_away} #{coach_away.name}"
    end
  end
end
