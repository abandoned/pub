# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pub/version"

Gem::Specification.new do |s|
  s.name        = "pub"
  s.version     = Pub::VERSION
  s.authors     = ["Hakan Ensari"]
  s.email       = ["hakan.ensari@papercavalier.com"]
  s.homepage    = "http://rubygems.com/papercavalier/pub"
  s.summary     = %q{A Redis-backed pub/sub messaging system for processing queues}
  s.description = %q{Pub is a Redis-backed pub/sub messaging system for processing queues.}

  s.rubyforge_project = "pub"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  {
    "eventmachine"        => "~> 1.0.0.beta.3",
    "em-synchrony"        => "~> 0.3.0.beta.1",
    "hiredis"             => "~> 0.3.1",
    "redis"               => "~> 2.2.1"
  }.each do |lib, version|
    s.add_runtime_dependency lib, version
  end

  {
    "rspec"               => "~> 2.6.0",
    "ruby-debug19"        => "~> 0.11.6"
  }.each do |lib, version|
    s.add_development_dependency lib, version
  end
end
