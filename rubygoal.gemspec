$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygoal/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Jorge Bejar']
  gem.email         = ['jorge@wyeworks.com']
  gem.description   = %q{Rubygoal}
  gem.summary       = %q{Rubygoal}
  gem.homepage      = 'https://github.com/wyeworks/rubygoal'
  gem.license       = 'Apache License 2.0'

  gem.files         = Dir['README.md', 'LICENSE', 'bin/**/*', 'lib/**/*', 'media/**/*', 'test/**/*']
  gem.test_files    = Dir['test/**/*']
  gem.executables   = %w[rubygoal]

  gem.name          = 'rubygoal'
  gem.require_paths = ['lib']
  gem.version       = Rubygoal::VERSION.to_s

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency 'gosu', '~> 0.7.50'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'minitest-reporters'
end
