# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pub/version"

Gem::Specification.new do |s|
  s.name        = "pub"
  s.version     = Pub::VERSION
  s.authors     = ["Paper Cavalier"]
  s.email       = "code@papercavalier.com"
  s.homepage    = "http://github.com/papercavalier/pub"
  s.summary     = "A Redis-backed pub with a non-blocking bar counter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9"

  {
    "em-synchrony"        => "~> 0.3.0.beta.1",
    "hiredis"             => "~> 0.3.2",
    "redis"               => "~> 2.2.1"
  }.each do |lib, version|
    s.add_runtime_dependency lib, version
  end

  {
    "cucumber"            => "~> 1.0",
    "rspec"               => "~> 2.6",
    "ruby-debug19"        => "~> 0.11"
  }.each do |lib, version|
    s.add_development_dependency lib, version
  end
end
