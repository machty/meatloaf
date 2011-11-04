require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('meatloaf', '0.1.1') do |p|
  p.description    = "Sass-based background-image Sprite generator"
  p.url            = "https://github.com/machty/meatloaf"
  p.author         = "Alex Matchneer"
  p.email          = "machty@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

