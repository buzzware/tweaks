require File.join(File.dirname(__FILE__),'tweak_config')

class Tweaks

	def self.reset
		@@configs = {}
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
	def self.define_tweak(aName,aWhen,aDefaults=nil,&block)
		aName = aName.to_sym
		aDefaults = TweakConfig.new(aDefaults)
		app_config = @@configs[aName.to_sym]
		install_now = [:enabled,true,:install_now,:now].include?(aWhen)
		if install_now || app_config
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
	def self.configure_tweak(aName,aConfig=nil)
		aName = aName.to_sym
		if have_defaults = have_config?(aName)							# will be defaults from define_tweak, so merge in app config
			config = @@configs[aName]
			config.read(aConfig) if aConfig
			@@configs[aName] = config
		else																# store app config for merge later
			@@configs[aName] = TweakConfig.new(aConfig)
		end
		do_it(aName) if have_defaults && !installed?(aName)
		@@configs[aName]
	end
	
end
	
