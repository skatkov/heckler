# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "standard/rake"

task default: %i[test standard]

desc "Build and install gem locally"
task :local_install do
  system "gem build heckler.gemspec"
  system "gem install ./heckler-#{Heckler::VERSION}.gem"
end
