Dir.chdir(File.dirname(__FILE__)) { Dir['tweaks/*.rb'] }.each {|f| require f }

