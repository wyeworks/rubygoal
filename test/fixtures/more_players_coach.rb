module Rubygoal
  class MorePlayersCoach < Coach
    def players
      {
        captain: [:captain],
        fast: [:fast1, :fast2, :fast3],
        average: [:average0, :average1, :average2, :average3, :average4, :average5, :average6]
      }
    end

    def name
      "Wanderers"
    end

    def formation(match)
      match.other.formation
    end
  end
end
