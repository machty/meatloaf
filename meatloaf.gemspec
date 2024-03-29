# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "meatloaf"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Matchneer"]
  s.date = "2011-11-04"
  s.description = "Sass-based background-image Sprite generator"
  s.email = "machty@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/meatloaf.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/meatloaf.rb", "meatloaf.gemspec", "Manifest"]
  s.homepage = "https://github.com/machty/meatloaf"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Meatloaf", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "meatloaf"
  s.rubygems_version = "1.8.10"
  s.summary = "Sass-based background-image Sprite generator"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
