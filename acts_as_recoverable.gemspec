Gem::Specification.new do |s|
  s.name = %q{acts_as_recoverable}
  s.version = "1.0.0"
 
  s.specification_version = 1 if s.respond_to? :specification_version=
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Revolution Health"]
  s.autorequire = %q{acts_as_recoverable}
  s.date = %q{2000-01-12}
  s.description = %q{}
  s.email = %q{rails@revolutionhealth.com}
  s.extra_rdoc_files = ["README", "TODO"]
  s.files = ["MIT-LICENSE","README.rdoc", "Rakefile","init.rb","install.rb","uninstall.rb","generators/**/*","lib/**/*","tasks/**/*"]
  s.has_rdoc = true
  s.homepage = %q{http://}
  s.require_paths = ["lib,generators,tasks"]
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{}
  s.add_dependency("activerecord", "~> 2.0") 
end
