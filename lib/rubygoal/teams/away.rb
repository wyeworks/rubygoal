require 'rubygoal/team'

module Rubygoal
  class AwayTeam < Team
    def initialize(*args)
      @side = :away
      @opponent_side = :home
      super
    end

    def teammate_is_on_front?(player, teammate)
      teammate.position.x < player.position.x - 40
    end
  end
end
