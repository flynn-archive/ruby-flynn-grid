require "bundler/gem_tasks"

desc "Run all tests by default"
task :default => "test:integration"

require "rake/testtask"
namespace :test do
  Rake::TestTask.new(:integration) do |t|
    t.libs << "test"
    t.pattern = "test/integration/test_*.rb"
  end
end
