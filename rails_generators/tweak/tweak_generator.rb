class TweakGenerator < Rails::Generator::Base

	TWEAKS_CONFIG_FILENAME = 'config/initializers/tweaks_config.rb'

  def manifest
    record do |m|
      m.directory "tweaks"
      m.template "tweak.erb", File.join("tweaks", "#{m.target.args.first}_tweak.rb") #:assigns => { :args => @gen_args }
			
			tweaks_config_filepath = File.expand_path(TWEAKS_CONFIG_FILENAME,RAILS_ROOT)
			tweaks_config_s = ''
			File.open(tweaks_config_filepath, "r") { |f| tweaks_config_s = f.read } if File.exists?(tweaks_config_filepath)
			STDOUT.puts "\n  Creating/appending #{m.target.args.first} config to #{tweaks_config_filepath}\n\n"
			tweaks_config_s += <<CONFIG_TEMPLATE

Tweaks.configure(
  :#{m.target.args.first},
  {
    # config values here
  }
)

CONFIG_TEMPLATE

			File.open(tweaks_config_filepath,'w') {|file| file.write tweaks_config_s }
		end			
	end	
				
  protected
  def banner
    "Usage: #{$0} #{spec.name} tweak_name"
  end

end
