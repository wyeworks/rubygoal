require 'minitest/autorun'

require 'rubygoal/game'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

module Rubygoal
  # Use only one Game instance when running tests to avoid this issue:
  # https://github.com/jlnr/gosu/issues/108
  def self.game_instance
    @game ||= Game.new
  end
end
