# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dataset}
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Williams"]
  s.date = %q{2009-12-29}
  s.description = %q{A simple API for creating and finding sets of data in your database, built on ActiveRecord.}
  s.email = %q{adam@thewilliams.ws}
  s.extra_rdoc_files = [
    "LICENSE",
     "README",
     "TODO"
  ]
  s.files = [
    "CHANGELOG",
     "LICENSE",
     "README",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "lib/dataset.rb",
     "lib/dataset/base.rb",
     "lib/dataset/collection.rb",
     "lib/dataset/database/base.rb",
     "lib/dataset/database/mysql.rb",
     "lib/dataset/database/postgresql.rb",
     "lib/dataset/database/sqlite3.rb",
     "lib/dataset/extensions/cucumber.rb",
     "lib/dataset/extensions/rspec.rb",
     "lib/dataset/extensions/test_unit.rb",
     "lib/dataset/instance_methods.rb",
     "lib/dataset/load.rb",
     "lib/dataset/record/fixture.rb",
     "lib/dataset/record/heirarchy.rb",
     "lib/dataset/record/meta.rb",
     "lib/dataset/record/model.rb",
     "lib/dataset/resolver.rb",
     "lib/dataset/session.rb",
     "lib/dataset/session_binding.rb",
     "lib/dataset/version.rb",
     "plugit/descriptor.rb",
     "tasks/dataset.rake"
  ]
  s.homepage = %q{http://github.com/aiwilliams/dataset}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib", "tasks"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple API for creating and finding sets of data in your database, built on ActiveRecord.}
  s.test_files = [
    "spec/dataset/cucumber_spec.rb",
     "spec/dataset/database/base_spec.rb",
     "spec/dataset/record/heirarchy_spec.rb",
     "spec/dataset/resolver_spec.rb",
     "spec/dataset/rspec_spec.rb",
     "spec/dataset/session_binding_spec.rb",
     "spec/dataset/session_spec.rb",
     "spec/dataset/test_unit_spec.rb",
     "spec/fixtures/datasets/constant_not_defined.rb",
     "spec/fixtures/datasets/ending_with_dataset.rb",
     "spec/fixtures/datasets/exact_name.rb",
     "spec/fixtures/datasets/not_a_dataset_base.rb",
     "spec/fixtures/more_datasets/in_another_directory.rb",
     "spec/models.rb",
     "spec/schema.rb",
     "spec/spec_helper.rb",
     "spec/stubs/mini_rails.rb",
     "spec/stubs/test_help.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.0"])
      s.add_dependency(%q<activerecord>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.0"])
    s.add_dependency(%q<activerecord>, [">= 2.3.0"])
  end
end

