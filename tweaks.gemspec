# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tweaks}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["buzzware"]
  s.date = %q{2010-11-15}
  s.description = %q{Tweaks provides a minimal framework for implementing, configuring and distributing those 
little pieces of code you develop and collect through developing multiple rails projects.}
  s.email = %q{contact@buzzware.com.au}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/tweak_config.rb",
     "lib/tweaks.rb",
     "pkg/tweaks-0.0.1.gem",
     "rails/init.rb",
     "rails_generators/tweak/templates/tweak.erb",
     "rails_generators/tweak/tweak_generator.rb",
     "test/config_spec.rb",
     "test/main_spec.rb",
     "test/test_helper.rb",
     "tweaks.gemspec",
     "tweaks.vpj",
     "tweaks.vpw"
  ]
  s.homepage = %q{http://github.com/buzzware/tweaks}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A minimal framework for implementing, configuring and distributing those little pieces of code}
  s.test_files = [
    "test/config_spec.rb",
     "test/main_spec.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

