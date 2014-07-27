# RubyGoal - Football for Rubyists
#
# This document contains several minimal implementations for a Rubygoal coach.
#
# This class must implement at least the methods `name` and `formation(match)`
# This class must be implemented within Rubygoal module.
module Rubygoal
  class MyCoach < Coach
    # Define player names for each type of player
    # These names will later be used to setup the lineup in the formation method
    # This method must return a hash with:
    # - captain: An array with one elment, the captains name
    # - fast: An array of 3 elements with the fast players' names
    # - average: An array of 6 elements with the average players' names
    def players
      {
        captain: [:captain],
        fast: [:fast1, :fast2, :fast3],
        average: [:average1, :average2, :average3, :average4, :average5, :average6]
      }
    end

    # Team's name
    # Method must always return the same string
    def name
      "My team name"
    end

    # Must return a Formation instance which indicates each player's position
    # This method is invoked several times per second
    # match parameter brings you information about match status
    def formation(match)
      formation = Formation.new

      # Field is divided into a 5x5 matrix as shown below.
      #   ------------------------------
      #   | N     N     N     N     N  |
      #   |                            |
      #   | N     N     N     N     N  |
      # G |                            | G
      # O | N     N     N     N     N  | O
      # A |                            | A
      # L | N     N     N     N     N  | L
      #   |                            |
      #   | N     N     N     N     N  |
      #   ------------------------------
      #
      # Each N represent a possible player's position inside the field
      # There are three kinds of players ( :average, :fast, :captain )
      # Each field position must be filled with some kind of player or ':none' for empty space.
      # :captain -> This is the fastest and most accurate player
      # :fast    -> These players are faster than :average players but
      # slower than :captain
      # :average -> These players haven't any special skills
      # It is not necessary to include the goalkeeper

      formation.defenders = [:none, :average1, :average2, :average3, :none]
      formation.midfielders = [:average4, :fast1, :captain, :none, :average5]
      formation.attackers = [:none, :fast2, :none, :fast3, :average6]
      # Above lineup produce
      #
      #   ------------------------------
      #   | N     N     A     N     N  |
      #   |                            |
      #   | A     N     F     N     F  |
      # G |                            | G
      # O | A     N     C     N     N  | O
      # A |                            | A
      # L | A     N     N     N     F  | L
      #   |                            |
      #   | N     N     A     N     A  |
      #   ------------------------------
      #

      formation
    end
  end

  class AnotherCoach < Coach
    def players
      {
        captain: [:captain],
        fast: [:fast1, :fast2, :fast3],
        average: [:average1, :average2, :average3, :average4, :average5, :average6]
      }
    end

    def name
      "Maeso FC"
    end

    # Next example shows how to control player's position
    # in a cleaner way using `lineup` method
    def formation(match)
      formation = Formation.new

      # Default formation.lineup value is
      # [
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      #   [:none, :none, :none, :none, :none],
      # ]
      #
      # This value must be overridden with a valid formation
      # You must consider that your opponent's goal is at your right
      # A 4-3-2-1 lineup could be implemented as shown below
      #                |                            |
      #      defense   |     midfield               | forward
      # [              |                            |
      #   [  :average, | :none, :average, :none,    | :none     ],
      #   [  :fast,    | :none, :none,    :average, | :none     ],
      #   [  :none,    | :none, :captain, :none,    | :fast     ],
      #   [  :fast,    | :none, :none,    :average, | :none     ],
      #   [  :average, | :none, :average, :none,    | :none     ],
      # ]              |                            |
      #                |                            |
         formation.lineup = [
        [:average1, :none, :average2, :none,    :none],
        [:fast1,    :none, :none,    :average3, :none],
        [:none,    :none, :captain, :none,    :fast2],
        [:fast3,    :none, :none,    :average4, :none],
        [:average5, :none, :average6, :none,    :none],
      ]

      formation
    end
  end

  # Next example shows how to change players's position when match is
  # being played
  class MyCoach < Coach
    def players
      {
        captain: [:captain],
        fast: [:fast1, :fast2, :fast3],
        average: [:average1, :average2, :average3, :average4, :average5, :average6]
      }
    end

    def name
      "Blue Tigers"
    end

    def formation(match)
      formation = Formation.new

      # `me` method brings information about my team in the match
      # me.winning?
      # me.losing?
      # me.draw?
      # me.score - returns the number of goals scored
      if match.me.winning?
        formation.defenders = [:average1, :average2, :average3, :captain, :average4]
        formation.midfielders = [:average5, :none, :fast1, :none, :average6]
        formation.attackers = [:none, :fast2, :none, :fast3, :none]
      # `time` method shows how much time ( seconds ) left
      elsif match.time < 10
        formation.defenders = [:none, :average1, :average2, :average3, :none]
        formation.midfielders = [:average4, :average5, :captain, :none, :average6]
        formation.attackers = [:fast1, :fast2, :none, :fast3, :none]
      else
      # `other` brings opponent's information ( just like `me` method )
      # Next line shows mirror strategy, in which my lineup is a copy
      # of the opponent lineup
        formation.lineup = match.other.formation.lineup
      end

      formation
    end
  end
end
