require 'minitest/autorun'

require 'rubygoal/game'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

module Rubygoal

  class Coordinate
    # Needed to use assert_in_delta with Coordinate instances
    alias_method :-, :distance
  end


  # Use only one Game instance when running tests to avoid this issue:
  # https://github.com/jlnr/gosu/issues/108
  def self.game_instance
    return @game if @game

    Random.srand(1)
    @game = Game.new
  end
end
