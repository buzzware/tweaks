config.after_initialize do
	Tweaks.load_all(File.join(File.dirname(__FILE__),'../tweaks'))
	Tweaks.load_all(File.join(RAILS_ROOT,'tweaks'))
end

