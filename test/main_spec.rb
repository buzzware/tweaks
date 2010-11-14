gem "buzzcore"; require 'buzzcore'
require_paths '.','../lib'
require 'tweaks'
#require File.join(File.dirname(__FILE__),'test_helper')

describe "tweaks" do

  before(:each) do
		Tweaks.reset()
	end

	it "should get execute immediately with define_and_install and correct config" do
		received_config = nil
		input_config = {:food => [:bacon, :bacon_salad, :pizza]}

		Tweaks.define_and_install(
			:lunch,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == input_config
	end

	it "should not get executed immediately on define, but is executed on config" do
		received_config = nil
		input_config = {:food => [:bacon, :bacon_salad, :pizza]}
		Tweaks.define(
			:lunch,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == nil
		Tweaks.configure(:lunch)
		received_config.should == input_config
	end
	

	it "should not get executed immediately, but is executed on config and has merged config" do
		received_config = nil
		input_config = {
			:name => String,
			:age => 52,
			:number_string => String,
			:a_symbol => Symbol
		}
		Tweaks.define(
			:person,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == nil
		Tweaks.configure(:person,{:number_string => 5, :name => 'Roger', :a_symbol => 'apple'})
		received_config.should == {
			:name => 'Roger',
			:number_string => '5',
			:age => 52,
			:a_symbol => :apple
		}
		received_config.class.should == TweakConfig
	end

	it "when configured before defined, should be executed on define and has merged config" do
		received_config = nil
		input_config = {
			:name => String,
			:age => 52,
			:number_string => String,
			:a_symbol => Symbol
		}
		Tweaks.configure(:person,{:number_string => 5, :name => 'Roger', :a_symbol => 'apple'})
		received_config.should == nil
		Tweaks.define(
			:person,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == {
			:name => 'Roger',
			:number_string => '5',
			:age => 52,
			:a_symbol => :apple
		}
		received_config.class.should == TweakConfig
	end

end

