module Rubygoal
  class Coach
    def name
      raise NotImplementedError
    end

    def formation(match)
      raise NotImplementedError
    end
  end
end
