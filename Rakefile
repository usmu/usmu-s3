lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'usmu/s3/version'

def current_gems
  Dir["pkg/usmu-s3-#{Usmu::S3::VERSION}*.gem"]
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'test/spec/**/*_spec.rb'
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'test/features'
end

desc 'Run all test scripts'
task :test => [:clean, :spec, :features]

desc 'Run CI test suite'
task :ci => [:spec]

desc 'Clean up after tests'
task :clean do
  current_gems.each {|f| rm f }
end

namespace :gem do
  desc 'Build gems'
  task :build => [:clean] do
    mkdir 'pkg' unless File.exist? 'pkg'
    Dir['*.gemspec'].each do |gemspec|
      sh "gem build #{gemspec}"
    end
    Dir['*.gem'].each do |gem|
      mv gem, "pkg/#{gem}"
    end
  end

  desc 'Install gem'
  task :install => ['gem:build'] do
    sh "gem install pkg/usmu-s3-#{Usmu::S3::VERSION}.gem"
  end

  desc 'Deploy gems to rubygems'
  task :deploy => ['gem:build'] do
    current_gems.each do |gem|
      sh "gem push #{gem}"
    end
    sh "git tag #{Usmu::S3::VERSION}" if File.exist? '.git'
  end
end
