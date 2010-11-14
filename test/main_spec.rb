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

	it "should not get executed immediately when given :install_later, but is executed on config" do
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
	end

end



#class MainTest < Test::Unit::TestCase

#	test "block gets correct config" do
#		assert true
		#received_config = nil
		#input_config = {:food => [:bacon, :bacon_salad, :pizza]}
    #
		#Tweak.define_tweak(
		#	:lunch,
		#	:install_now,
		#	input_config
		#)	do |config,name|
		#	received_config = config
		#end
		#assert_equals(input_config,received_config)
#	end
	
#	test "" do
#	end


	#test "normally enabled then disabled in config doesn't cause it to run"
	#test "normally enabled then disabled in config doesn't cause it to run"
	#test "config default and reading works"


	#With normally enabled and no config required and do_it always called in the config - how would it get called ?
	#perhaps need Tweaks.do_default_configured_tweaks()
  #
	#or
  #
	#Forget normally enabled/disabled : Always normally disabled, in config must Tweaks.configure_tweak(:name,{...}) or at least
	#Tweaks.configure_tweak(:name)
  #
	#Maybe :enabled_now and no config allowed or required
  #
	# ! Answer !
	#
	#:install_now		# install now with defaults
	#:install_later	# config and install later in tweaks_config


#end

