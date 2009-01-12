require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'test/unit'
 
GEM = "acts_as_recoverable"
GEM_VERSION = "1.0.0"
AUTHOR = "Revolution Health"
EMAIL = "rails@revolutionhealth.com"
HOMEPAGE = "http://"
SUMMARY = ""
 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "Rakefile"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  s.add_dependency("activerecord", "~> 2.0")
  
  s.require_path = 'lib,generators,tasks'
  s.autorequire = GEM
  s.files = %w(README.rdoc Rakefile acts_as_recoverable.gemspec init.rb install.rb uninstall.rb) + Dir.glob("{lib,tasks,generators}/**/*")
end
 
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{spec.name}-#{spec.version}}
end
 
desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
 
task :test do
 runner = Test::Unit::AutoRunner.new(true)
 runner.to_run << 'test'
 runner.pattern = [/_test.rb$/]
 exit if !runner.run
end
 
task :default => [:test, :package] do
end
 