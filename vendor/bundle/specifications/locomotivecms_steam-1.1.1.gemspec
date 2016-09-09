# -*- encoding: utf-8 -*-
# stub: locomotivecms_steam 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "locomotivecms_steam"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Didier Lafforgue", "Rodrigo Alvarez", "Arnaud Sellenet", "Joel Azemar"]
  s.date = "2016-04-27"
  s.description = "The LocomotiveCMS Steam is the rendering stack used by both Wagon and Engine"
  s.email = ["did@locomotivecms.com", "papipo@gmail.com", "arnaud@sellenet.fr", "joel.azemar@gmail.com"]
  s.executables = ["steam.rb"]
  s.files = ["bin/steam.rb"]
  s.homepage = "https://github.com/locomotivecms/steam"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.5.1"
  s.summary = "The LocomotiveCMS Steam is the rendering stack used by both Wagon and Engine"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_development_dependency(%q<mongo>, ["~> 2.2.3"])
      s.add_development_dependency(%q<origin>, ["~> 2.1.1"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6.7.2"])
      s.add_runtime_dependency(%q<sanitize>, ["~> 4.0.1"])
      s.add_runtime_dependency(%q<morphine>, ["~> 0.1.1"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.13.6"])
      s.add_runtime_dependency(%q<chronic>, ["~> 0.10.2"])
      s.add_runtime_dependency(%q<rack-rewrite>, ["~> 1.5.1"])
      s.add_runtime_dependency(%q<rack-cache>, ["~> 1.6.1"])
      s.add_runtime_dependency(%q<dragonfly>, ["~> 1.0.12"])
      s.add_runtime_dependency(%q<moneta>, ["~> 0.8.0"])
      s.add_runtime_dependency(%q<rack_csrf>, ["~> 2.5.0"])
      s.add_runtime_dependency(%q<sprockets>, ["~> 3.5.2"])
      s.add_runtime_dependency(%q<sass>, ["~> 3.4.21"])
      s.add_runtime_dependency(%q<coffee-script>, ["~> 2.4.1"])
      s.add_runtime_dependency(%q<compass>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<autoprefixer-rails>, ["~> 6.3.3.1"])
      s.add_runtime_dependency(%q<kramdown>, ["~> 1.10.0"])
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.2.9"])
      s.add_runtime_dependency(%q<haml>, ["~> 4.0.6"])
      s.add_runtime_dependency(%q<mimetype-fu>, ["~> 0.1.2"])
      s.add_runtime_dependency(%q<mime-types>, ["~> 2.6.1"])
      s.add_runtime_dependency(%q<locomotivecms-solid>, ["~> 4.0.1"])
      s.add_runtime_dependency(%q<locomotivecms_common>, ["~> 0.2.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.4.2"])
      s.add_dependency(%q<mongo>, ["~> 2.2.3"])
      s.add_dependency(%q<origin>, ["~> 2.1.1"])
      s.add_dependency(%q<nokogiri>, ["~> 1.6.7.2"])
      s.add_dependency(%q<sanitize>, ["~> 4.0.1"])
      s.add_dependency(%q<morphine>, ["~> 0.1.1"])
      s.add_dependency(%q<httparty>, ["~> 0.13.6"])
      s.add_dependency(%q<chronic>, ["~> 0.10.2"])
      s.add_dependency(%q<rack-rewrite>, ["~> 1.5.1"])
      s.add_dependency(%q<rack-cache>, ["~> 1.6.1"])
      s.add_dependency(%q<dragonfly>, ["~> 1.0.12"])
      s.add_dependency(%q<moneta>, ["~> 0.8.0"])
      s.add_dependency(%q<rack_csrf>, ["~> 2.5.0"])
      s.add_dependency(%q<sprockets>, ["~> 3.5.2"])
      s.add_dependency(%q<sass>, ["~> 3.4.21"])
      s.add_dependency(%q<coffee-script>, ["~> 2.4.1"])
      s.add_dependency(%q<compass>, ["~> 1.0.3"])
      s.add_dependency(%q<autoprefixer-rails>, ["~> 6.3.3.1"])
      s.add_dependency(%q<kramdown>, ["~> 1.10.0"])
      s.add_dependency(%q<RedCloth>, ["~> 4.2.9"])
      s.add_dependency(%q<haml>, ["~> 4.0.6"])
      s.add_dependency(%q<mimetype-fu>, ["~> 0.1.2"])
      s.add_dependency(%q<mime-types>, ["~> 2.6.1"])
      s.add_dependency(%q<locomotivecms-solid>, ["~> 4.0.1"])
      s.add_dependency(%q<locomotivecms_common>, ["~> 0.2.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.4.2"])
    s.add_dependency(%q<mongo>, ["~> 2.2.3"])
    s.add_dependency(%q<origin>, ["~> 2.1.1"])
    s.add_dependency(%q<nokogiri>, ["~> 1.6.7.2"])
    s.add_dependency(%q<sanitize>, ["~> 4.0.1"])
    s.add_dependency(%q<morphine>, ["~> 0.1.1"])
    s.add_dependency(%q<httparty>, ["~> 0.13.6"])
    s.add_dependency(%q<chronic>, ["~> 0.10.2"])
    s.add_dependency(%q<rack-rewrite>, ["~> 1.5.1"])
    s.add_dependency(%q<rack-cache>, ["~> 1.6.1"])
    s.add_dependency(%q<dragonfly>, ["~> 1.0.12"])
    s.add_dependency(%q<moneta>, ["~> 0.8.0"])
    s.add_dependency(%q<rack_csrf>, ["~> 2.5.0"])
    s.add_dependency(%q<sprockets>, ["~> 3.5.2"])
    s.add_dependency(%q<sass>, ["~> 3.4.21"])
    s.add_dependency(%q<coffee-script>, ["~> 2.4.1"])
    s.add_dependency(%q<compass>, ["~> 1.0.3"])
    s.add_dependency(%q<autoprefixer-rails>, ["~> 6.3.3.1"])
    s.add_dependency(%q<kramdown>, ["~> 1.10.0"])
    s.add_dependency(%q<RedCloth>, ["~> 4.2.9"])
    s.add_dependency(%q<haml>, ["~> 4.0.6"])
    s.add_dependency(%q<mimetype-fu>, ["~> 0.1.2"])
    s.add_dependency(%q<mime-types>, ["~> 2.6.1"])
    s.add_dependency(%q<locomotivecms-solid>, ["~> 4.0.1"])
    s.add_dependency(%q<locomotivecms_common>, ["~> 0.2.0"])
  end
end
