require File.join(File.dirname(__FILE__),'tweak_config')

class Tweaks

	@@configs = {}
	@@switch = {}
	@@switch_default = {}
	@@procs = {}
	@@installed = []

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
	
	#def self.enable(*aTweakNames)
	#	aTweakNames = [aTweakNames] unless aTweakNames.is_a?(Array)
	#	aTweakNames.each do |n|
	#		@@switch[n.to_sym] = true
	#	end
	#end
  #
	#def self.disable(*aTweakNames)
	#	aTweakNames = [aTweakNames] unless aTweakNames.is_a?(Array)
	#	aTweakNames.each do |n|
	#		@@switch[n.to_sym] = false
	#	end
	#end
  #
	#def self.header_enabled?(aTweak)
	#end
  #
	#def self.header_disabled?(aTweak)
	#end

	# pass a hash to set
	# returns config hash for modification
	def self.configure_tweak(aTweak,aConfig=nil)
		aTweak = aTweak.to_sym
		#if !(cf = @@configs[aTweak])
		#	cf = TweakConfig.new({})
		#	@@configs[aTweak] = cf
		#end
		cf = @@configs[aTweak]
		cf.read(aConfig) if aConfig
		@@configs[aTweak] = cf
		do_it(aTweak)
		cf
	end

	# called by tweak code (not sure if necessary)
	# aDefaults creates an optional config object for this tweak with the given defaults and previously given values
	# aNormally :enabled or :disabled
	def self.define_tweak(aName,aWhen,aDefaults=nil,&block)
		aName = aName.to_sym
		aDefaults ||= {}
		@@configs[aName.to_sym] = TweakConfig.new(aDefaults)
		if install_now = [:enabled,true,:install_now].include?(aWhen)
			do_it(aName,&block)
			@@installed << aName
		else
			@@procs[aName] = block.to_proc
		end
		install_now
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

	def self.enabled?(aTweakName)
		@@switch[aTweakName.to_sym]==nil ? @@switch_default[aTweakName.to_sym] : @@switch[aTweakName.to_sym]
	end

end
	
