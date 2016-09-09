# -*- encoding: utf-8 -*-
# stub: morphine 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "morphine"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brandon Keepers"]
  s.date = "2012-09-27"
  s.description = "Morphine is a lightweight dependency injection framework for Ruby. It uses a simple Ruby DSL to ease the pain of wiring your dependencies together."
  s.email = ["brandon@opensoul.org"]
  s.homepage = ""
  s.rubyforge_project = "morphine"
  s.rubygems_version = "2.5.1"
  s.summary = "A lightweight dependency injection framework for Ruby"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0"])
  end
end
