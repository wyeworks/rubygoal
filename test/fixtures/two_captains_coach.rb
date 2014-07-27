module Rubygoal
  class TwoCaptainsCoach < Coach
    def players
      {
        captain: [:captain, :captain2],
        fast: [:fast1, :fast2, :fast3],
        average: [:average2, :average3, :average4, :average5, :average6]
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
