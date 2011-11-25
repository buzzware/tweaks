require File.join(File.dirname(__FILE__),'tweak_config')

class Tweaks

	def self.reset
		@@configs = {}	# may contain defaults or config
		@@procs = {}
		@@installed = []
	end
	reset()

	# load all tweaks from a path
	def self.load_all(aPath)
		aPath = File.expand_path(aPath)
		# get list of tweak_files
		tweak_files = Dir.glob(File.join(aPath,'*_tweak.rb'))
		tweak_files.each do |f|
			Tweaks.load(f)
		end
	end
	
	def self.load(aTweakFile)
		if defined? Rails
			require_dependency aTweakFile
		else
			::Kernel.load(aTweakFile)
		end
	end
	
	def self.do_it(aName,&block)
		return unless block_given? || (p = @@procs[aName])
		@@installed << aName
		config = @@configs[aName]
		if block_given?
			yield(config,aName)
		else
			p.call(config,aName)
		end
	end
	
	# called by tweak code (not sure if necessary)
	# aDefaults creates an optional config object for this tweak with the given defaults and previously given values
	# aNormally :enabled or :disabled
	def self.define(aName,aDefaults=nil,&block)
		aName = aName.to_sym
		aDefaults = TweakConfig.new(aDefaults)
		app_config = @@configs[aName.to_sym]
		if app_config
			@@configs[aName] = (app_config ? aDefaults.read(app_config) : aDefaults)
			do_it(aName,&block)
		else
			@@configs[aName] = aDefaults
			@@procs[aName] = block.to_proc
		end
	end
	
	def self.have_config?(aName)
		!!@@configs[aName.to_sym]
	end

	def self.installed?(aName)
		!!@@installed.include?(aName.to_sym)
	end

	# pass a hash to set
	# returns config hash for modification
	def self.configure(aName,aConfig=nil)
		aName = aName.to_sym
		if have_config?(aName)							# will be defaults from define, so merge in app config
			config = @@configs[aName]
			config.read(aConfig) if aConfig
			@@configs[aName] = config
		else																# store app config for merge later
			@@configs[aName] = TweakConfig.new(aConfig)
		end
		do_it(aName) if @@procs[aName] && !installed?(aName)	# we have configured here, so install if we have define proc and not already installed
		@@configs[aName]
	end
	
	def self.define_and_install(aName,aConfig=nil,&block)
		define(aName,aConfig,&block)
		configure(aName)
	end
	
	
end
	
