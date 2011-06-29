require "bundler/gem_tasks"
require "cucumber/rake/task"
require "rspec/core/rake_task"

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

task :default => [:spec, :features]
