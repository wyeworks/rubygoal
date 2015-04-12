module Rubygoal
  class FourFastPlayersCoachDefinition < CoachDefinition
    def players
      [
        PlayerDefinition.new(:captain, :captain),
        PlayerDefinition.new(:fast1, :fast),
        PlayerDefinition.new(:fast2, :fast),
        PlayerDefinition.new(:fast3, :fast),
        PlayerDefinition.new(:fast4, :fast),
        PlayerDefinition.new(:average1, :average),
        PlayerDefinition.new(:average2, :average),
        PlayerDefinition.new(:average3, :average),
        PlayerDefinition.new(:average4, :average),
        PlayerDefinition.new(:average5, :average),
        PlayerDefinition.new(:average6, :average),
      ]
    end

    def name
      "Wanderers"
    end

    def formation(match)
      match.other.formation
    end
  end
end
