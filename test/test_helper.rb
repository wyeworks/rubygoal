require 'minitest/autorun'

require 'rubygoal/game'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

module Rubygoal

  class Coordinate
    # Needed to use assert_in_delta with Coordinate instances
    alias_method :-, :distance
  end
end
