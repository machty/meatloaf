require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('meatloaf', '0.1.0') do |p|
  p.description    = "Compiles similar bg images into one, using SASS directives."
  p.url            = "https://github.com/machty/meatloaf"
  p.author         = "Alex Matchneer"
  p.email          = "machty@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

