class Tweaks

	@@configs = {}
	@@switch = {}
	@@switch_default = {}

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
	
	def self.enable(*aTweakNames)
		aTweakNames = [aTweakNames] unless aTweakNames.is_a?(Array)
		aTweakNames.each do |n|
			@@switch[n.to_sym] = true
		end
	end

	def self.disable(*aTweakNames)
		aTweakNames = [aTweakNames] unless aTweakNames.is_a?(Array)
		aTweakNames.each do |n|
			@@switch[n.to_sym] = false
		end
	end

	def self.header_enabled?(aTweak)
	end
	
	def self.header_disabled?(aTweak)
	end

	# pass a hash to set
	# returns config hash for modification
	def self.configure_tweak(aTweak,aHash=nil)
		aTweak = aTweak.to_sym
		if !(cf = @@configs[aTweak])
			cf = {}
			@@configs[aTweak] = cf
		end
		if aHash
			if cf.is_a?(ConfigClass)
				cf.reset()
				cf.read(aHash)
			else
				@@configs[aTweak] = cf = aHash	
			end
		end
		cf
	end

	# called by tweak code (not sure if necessary)
	# aDefaults creates an optional config object for this tweak with the given defaults and previously given values
	# aNormally :enabled or :disabled
	def self.define_tweak(aName,aNormally,aDefaults=nil)
		config = @@configs[aName.to_sym]
		@@configs[aName.to_sym] = config = ConfigClass.new(aDefaults,config) if aDefaults
		@@switch_default[aName.to_sym] = (aNormally==:enabled || aNormally==true ? true : false)
		en = enabled?(aName)
		yield(config,aName) if en
		en
	end

	def self.enabled?(aTweakName)
		@@switch[aTweakName.to_sym]==nil ? @@switch_default[aTweakName.to_sym] : @@switch[aTweakName.to_sym]
	end

end
	
