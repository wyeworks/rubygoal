module Rubygoal
  class CoachDefinition
    PlayerDefinition = Struct.new(:name, :type)

    class << self
      attr_reader :team_name

      def team(&block)
        instance_eval(&block)
      end

      def name(team_name)
        @team_name = team_name
      end

      def players(&block)
        @team_players = []
        instance_eval(&block)
      end

      def method_missing(method, *args)
        name = args.first.to_sym
        @team_players << PlayerDefinition.new(name, method.to_sym)
      end

      def team_players
        @team_players || [
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
    end

    def players
      self.class.team_players
    end

    def name
      self.class.team_name
    end

    def formation(match)
      raise NotImplementedError
    end
  end
end
