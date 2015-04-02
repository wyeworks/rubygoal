module Rubygoal
  class CoachDefinition
    PlayerDefinition = Struct.new(:name, :type)

    def players
      [
        PlayerDefinition.new(:captain, :captain),
        PlayerDefinition.new(:fast1, :fast),
        PlayerDefinition.new(:fast2, :fast),
        PlayerDefinition.new(:fast3, :fast),
        PlayerDefinition.new(:average1, :average),
        PlayerDefinition.new(:average2, :average),
        PlayerDefinition.new(:average3, :average),
        PlayerDefinition.new(:average4, :average),
        PlayerDefinition.new(:average5, :average),
        PlayerDefinition.new(:average6, :average),
      ]
    end

    def name
      raise NotImplementedError
    end

    def formation(match)
      raise NotImplementedError
    end
  end
end
