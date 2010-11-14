gem "buzzcore"; require 'buzzcore'
require_paths '.','../lib'
require 'tweaks'
#require File.join(File.dirname(__FILE__),'test_helper')

describe "tweaks" do

	it "should get execute immediately with correct config when given :install_now" do
		received_config = nil
		input_config = {:food => [:bacon, :bacon_salad, :pizza]}

		Tweaks.define_tweak(
			:lunch,
			:install_now,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == input_config
	end

	it "should not get executed immediately when given :install_later, but is executed on config" do
		received_config = nil
		input_config = {:food => [:bacon, :bacon_salad, :pizza]}
		Tweaks.define_tweak(
			:lunch,
			:install_later
		)	do |config,name|
			received_config = input_config
		end
		received_config.should == nil
		Tweaks.configure_tweak(:lunch)
		received_config.should == input_config
	end

	it "should not get executed immediately when given :install_later, but is executed on config and has merged config" do
		received_config = nil
		input_config = {
			:name => String,
			:age => 52,
			:number_string => String,
			:a_symbol => Symbol
		}
		Tweaks.define_tweak(
			:person,
			:install_later,
			input_config
		)	do |config,name|
			received_config = config
		end
		received_config.should == nil
		Tweaks.configure_tweak(:person,{:number_string => 5, :name => 'Roger', :a_symbol => 'apple'})
		received_config.should == {
			:name => 'Roger',
			:number_string => '5',
			:age => 52,
			:a_symbol => :apple
		}
		received_config.class.should == TweakConfig
	end

end

