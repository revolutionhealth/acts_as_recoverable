Gem::Specification.new do |s|
  s.name = %q{acts_as_recoverable}
  s.version = "1.0.4"
 
  s.specification_version = 1 if s.respond_to? :specification_version=
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Revolution Health"]
  s.autorequire = %q{acts_as_recoverable}
  s.date = %q{2000-01-12}
  s.description = %q{A plugin for ActiveRecord that allows for easy recovery of deleted models.}
  s.email = %q{rails@revolutionhealth.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["MIT-LICENSE","README.rdoc", "Rakefile","init.rb","install.rb","uninstall.rb","generators/recoverable_objects_migration/templates/migration.rb","generators/recoverable_objects_migration/recoverable_objects_migration_generator.rb","generators/recoverable_objects_migration/USAGE",
  			 "lib/acts_as_recoverable.rb","lib/recoverable_object.rb","tasks/acts_as_recoverable_tasks.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A plugin for ActiveRecord that allows for easy recovery of deleted models.}
  s.add_dependency("activerecord", "~> 2.0") 
end
