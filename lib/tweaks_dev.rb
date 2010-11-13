# when you want to load the live version of buzzcore, not the gem :
# require File.join(File.dirname(__FILE__),'../../../../../buzzcore/lib/buzzcore_dev.rb');
require File.join(File.dirname(__FILE__),'buzzcore/require_paths')	# load require_paths early for next line
require_paths_first '.'
require 'tweaks'

