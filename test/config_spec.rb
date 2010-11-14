gem "buzzcore"; require 'buzzcore'
require_paths '.','../lib'
require 'tweaks'
#require File.join(File.dirname(__FILE__),'test_helper')

describe "tweaks" do
	it "create config and access" do
		
		default_config = {
			:name => String,
			:age => 52,
			:number_string => String,
			:a_symbol => Symbol
		}
		later_config = {
			:number_string => 5, :name => 'Roger', :a_symbol => 'apple'
		}		
		result_config = TweakConfig.new(default_config,later_config)
		result_config.should == {
			:name => 'Roger',
			:number_string => '5',
			:age => 52,
			:a_symbol => :apple
		}
	end
end
