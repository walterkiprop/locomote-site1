# -*- encoding: utf-8 -*-
# stub: locomotivecms_common 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "locomotivecms_common"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Didier Lafforgue", "Arnaud Sellenet", "Joel Azemar"]
  s.date = "2016-04-27"
  s.description = "The LocomotiveCMS Common is a shared libraries package"
  s.email = ["did@locomotivecms.com", "arnaud@sellenet.fr", "joel.azemar@gmail.com"]
  s.homepage = "https://github.com/locomotivecms/common"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new("~> 2.0")
  s.rubygems_version = "2.5.1"
  s.summary = "The LocomotiveCMS Common is a shared libraries package for all LocomotiveCMS dependencies"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 4.2.6"])
      s.add_runtime_dependency(%q<stringex>, ["~> 2.6.0"])
      s.add_runtime_dependency(%q<attr_extras>, ["~> 4.4.0"])
      s.add_runtime_dependency(%q<colorize>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<activesupport>, ["~> 4.2.6"])
      s.add_dependency(%q<stringex>, ["~> 2.6.0"])
      s.add_dependency(%q<attr_extras>, ["~> 4.4.0"])
      s.add_dependency(%q<colorize>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<activesupport>, ["~> 4.2.6"])
    s.add_dependency(%q<stringex>, ["~> 2.6.0"])
    s.add_dependency(%q<attr_extras>, ["~> 4.4.0"])
    s.add_dependency(%q<colorize>, [">= 0"])
  end
end
