require 'rubygoal/coach'
require 'rubygoal/formation'

module Rubygoal
  class TestMirror < Coach

    def name
      "Racing"
    end

    def players
      {
        captain: [:capitan],
        fast: [:rapido1, :rapido2, :rapido3],
        average: [:average01, :average02, :average03, :average04, :average05, :average06]
      }
    end

    def formation(match)
      mirror_formation(match.other.lineup)
    end
  end
end
