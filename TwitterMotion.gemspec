# -*- encoding: utf-8 -*-
require File.expand_path('../lib/twittermotion/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "twittermotion"
  s.version     = Twitter::VERSION
  s.authors     = ["Clay Allsopp"]
  s.email       = ["clay.allsopp@gmail.com"]
  s.homepage    = "https://github.com/clayallsopp/twittermotion"
  s.summary     = "A RubyMotion Twitter Wrapper"
  s.description = "A RubyMotion Twitter Wrapper"

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end