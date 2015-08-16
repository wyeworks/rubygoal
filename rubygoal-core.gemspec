$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygoal/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Jorge Bejar']
  gem.email         = ['jorge@wyeworks.com']
  gem.description   = %q{Rubygoal core}
  gem.summary       = %q{Rubygoal core}
  gem.homepage      = 'https://github.com/wyeworks/rubygoal'
  gem.license       = 'Apache License 2.0'

  gem.files         = Dir['README.md', 'LICENSE', 'lib/**/*', 'test/**/*']
  gem.test_files    = Dir['test/**/*']

  gem.name          = 'rubygoal-core'
  gem.require_paths = ['lib']
  gem.version       = Rubygoal::VERSION.to_s

  gem.required_ruby_version = '>= 2.2.2'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'minitest-reporters'
end
