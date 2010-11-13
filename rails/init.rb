config.after_initialize do
	Tweaks::Core.load_all(File.join(File.dirname(__FILE__),'../tweaks'))
	Tweaks::Core.load_all(File.join(RAILS_ROOT,'tweaks'))
end

