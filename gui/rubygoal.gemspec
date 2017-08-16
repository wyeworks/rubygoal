$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygoal/gui/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Jorge Bejar']
  gem.email         = ['jorge@wyeworks.com']
  gem.description   = %q{Rubygoal}
  gem.summary       = %q{Rubygoal Game - Soccer game for Rubysts}
  gem.homepage      = 'https://github.com/wyeworks/rubygoal'
  gem.license       = 'Apache License 2.0'

  gem.files         = Dir['README.md', 'LICENSE', 'bin/**/*', 'lib/**/*', 'media/**/*']
  gem.executables   = %w[rubygoal]

  gem.name          = 'rubygoal'
  gem.require_paths = ['lib']
  gem.version       = Rubygoal::Gui::VERSION.to_s

  gem.required_ruby_version = '>= 2.2.2'

  gem.add_dependency 'rubygoal-core', '~> 1.1'
  gem.add_dependency 'gosu', '~> 0.9'
end
