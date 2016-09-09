# -*- encoding: utf-8 -*-
# stub: locomotivecms_wagon 2.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "locomotivecms_wagon"
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Didier Lafforgue", "Rodrigo Alvarez"]
  s.date = "2016-04-27"
  s.description = "The LocomotiveCMS wagon is a site generator for the LocomotiveCMS engine"
  s.email = ["did@locomotivecms.com", "papipo@gmail.com"]
  s.executables = ["wagon"]
  s.files = ["bin/wagon"]
  s.homepage = "http://www.locomotivecms.com"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "The LocomotiveCMS wagon is a site generator for the LocomotiveCMS engine powered by all the efficient and modern HTML development tools (Haml, SASS, Compass, Less)."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.0.4"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_runtime_dependency(%q<thin>, ["~> 1.6.3"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 1.1.7"])
      s.add_runtime_dependency(%q<netrc>, ["~> 0.10.3"])
      s.add_runtime_dependency(%q<locomotivecms_coal>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<locomotivecms_steam>, ["~> 1.1.1"])
      s.add_runtime_dependency(%q<listen>, ["~> 3.0.4"])
      s.add_runtime_dependency(%q<rack-livereload>, ["~> 0.3.16"])
      s.add_runtime_dependency(%q<yui-compressor>, ["~> 0.12.0"])
      s.add_runtime_dependency(%q<faker>, ["~> 1.6"])
    else
      s.add_dependency(%q<rake>, ["~> 10.0.4"])
      s.add_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_dependency(%q<thin>, ["~> 1.6.3"])
      s.add_dependency(%q<rubyzip>, ["~> 1.1.7"])
      s.add_dependency(%q<netrc>, ["~> 0.10.3"])
      s.add_dependency(%q<locomotivecms_coal>, ["~> 1.2.0"])
      s.add_dependency(%q<locomotivecms_steam>, ["~> 1.1.1"])
      s.add_dependency(%q<listen>, ["~> 3.0.4"])
      s.add_dependency(%q<rack-livereload>, ["~> 0.3.16"])
      s.add_dependency(%q<yui-compressor>, ["~> 0.12.0"])
      s.add_dependency(%q<faker>, ["~> 1.6"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.0.4"])
    s.add_dependency(%q<thor>, ["~> 0.19.1"])
    s.add_dependency(%q<thin>, ["~> 1.6.3"])
    s.add_dependency(%q<rubyzip>, ["~> 1.1.7"])
    s.add_dependency(%q<netrc>, ["~> 0.10.3"])
    s.add_dependency(%q<locomotivecms_coal>, ["~> 1.2.0"])
    s.add_dependency(%q<locomotivecms_steam>, ["~> 1.1.1"])
    s.add_dependency(%q<listen>, ["~> 3.0.4"])
    s.add_dependency(%q<rack-livereload>, ["~> 0.3.16"])
    s.add_dependency(%q<yui-compressor>, ["~> 0.12.0"])
    s.add_dependency(%q<faker>, ["~> 1.6"])
  end
end
