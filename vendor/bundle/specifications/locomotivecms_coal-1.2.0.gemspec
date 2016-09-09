# -*- encoding: utf-8 -*-
# stub: locomotivecms_coal 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "locomotivecms_coal"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Didier Lafforgue"]
  s.date = "2016-04-27"
  s.description = "The LocomotiveCMS Coal is the API ruby client for the LocomotiveCMS platform"
  s.email = ["did@locomotivecms.com"]
  s.homepage = "https://github.com/locomotivecms/coal"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.5.1"
  s.summary = "The LocomotiveCMS Coal is the API ruby client for the LocomotiveCMS platform"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.11.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_runtime_dependency(%q<httpclient>, ["~> 2.7.1"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.9.1"])
      s.add_runtime_dependency(%q<faraday_middleware>, ["~> 0.10.0"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 4.2.6"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.11.2"])
      s.add_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_dependency(%q<httpclient>, ["~> 2.7.1"])
      s.add_dependency(%q<faraday>, ["~> 0.9.1"])
      s.add_dependency(%q<faraday_middleware>, ["~> 0.10.0"])
      s.add_dependency(%q<activesupport>, ["~> 4.2.6"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.11.2"])
    s.add_dependency(%q<rake>, ["~> 10.4.2"])
    s.add_dependency(%q<httpclient>, ["~> 2.7.1"])
    s.add_dependency(%q<faraday>, ["~> 0.9.1"])
    s.add_dependency(%q<faraday_middleware>, ["~> 0.10.0"])
    s.add_dependency(%q<activesupport>, ["~> 4.2.6"])
  end
end
