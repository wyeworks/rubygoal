require 'rubygoal/team'

module Rubygoal
  class HomeTeam < Team
    def initialize(*args)
      @side = :home
      @opponent_side = :away
      super
    end

    def teammate_is_on_front?(player, teammate)
      teammate.position.x > player.position.x + 40
    end
  end
end
