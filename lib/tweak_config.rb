# This is a cutdown version of ConfigClass from the buzzcore gem, and still is a bit messy.
# The idea is that the config can be declared with default values (enabling a reset to defaults),
# and that fields are implicitly declared with a type and value. New values for existing fields
# will then be converted to the original type. This is particularly useful eg if the values all 
# come in as strings, but need to operate as other types
#
# use like this :
#
# config = TweakConfig.new(
#		:something => String,									# giving a class means the type is the given class, and the default value is nil
#		:session_key => '_session',
#		:upload_path=> 'cms/uploads',
#		:thumbs_cache => File.expand_path('public/thumbs_cache',RAILS_ROOT),	# make sure this exists with correct permissions
#		:thumbs_url => '/thumbs_cache'
#		:delay => 3.5,
#		:log_level => :warn
#	)

class TweakConfig < Hash

	attr_reader :default_values

	def initialize(aDefaultValues=nil,aGivenValues=nil)
		@default_values = (aDefaultValues ? aDefaultValues.clone : {})
		reset()
		read(aGivenValues) if aGivenValues
	end
	
	# reset values back to defaults
	def reset
		self.clear
		me = self
		@default_values.each {|n,v| me[n] = v.is_a?(Class) ? nil : v}
	end
	
	def self.to_integer(aValue,aDefault=nil)
		t = aValue.strip
		return aDefault if t.empty? || !t.index(/^-{0,1}[0-9]+$/)
		return t.to_i
	end
	
	def self.to_float(aValue,aDefault=nil)
		t = aValue.strip
		return aDefault if !t =~ /(\+|-)?([0-9]+\.?[0-9]*|\.[0-9]+)([eE](\+|-)?[0-9]+)?/
		return t.to_f
	end

	def set_int(aKey,aValue)
		case aValue
			when String then    self[aKey] = TweakConfig::to_integer(aValue,self[aKey]);	#  aValue.to_integer(self[aKey]);
			when Fixnum then    self[aKey] = aValue;
			when Float then     self[aKey] = aValue.to_i;
		end
	end

	def set_float(aKey,aValue)
		case aValue
			when String then    self[aKey] = TweakConfig::to_float(aValue,self[aKey])	# aValue.to_float(self[aKey]);
			when Fixnum then    self[aKey] = aValue.to_f;
			when Float then     self[aKey] = aValue;
		end
	end

	def set_boolean(aKey,aValue)
		case aValue
			when TrueClass,FalseClass then   self[aKey] = aValue;
			when String then    self[aKey] = (['1','yes','y','true','on'].include?(aValue.downcase))
		else
			set_boolean(aKey,aValue.to_s)
		end
	end
	
	def set_symbol(aKey,aValue)
		case aValue
			when String then    self[aKey] = (aValue.to_sym rescue nil);
			when Symbol then    self[aKey] = aValue;
		end
	end

	def copy_item(aHash,aKey)
		d = default_values[aKey]
		d_class = (d.is_a?(Class) ? d : d.class)
		cname = d_class.name.to_sym
		case cname
			when :String then self[aKey] = aHash[aKey].to_s unless aHash[aKey].nil?
			when :Float then set_float(aKey,aHash[aKey]);
			when :Fixnum then set_int(aKey,aHash[aKey]);
			when :TrueClass, :FalseClass then set_boolean(aKey,aHash[aKey]);
			when :Symbol then self[aKey] = (aHash[aKey].to_sym rescue nil)
			when :Proc then self[aKey] = aHash[aKey] if aHash[aKey].is_a?(Proc)
			else
				self[aKey] = aHash[aKey]
		end
	end

	def read(aSource,aLimitToDefaults=false)
		aSource.each do |k,v|
			copy_item(aSource,k) unless aLimitToDefaults && !default_values.include?(k)
		end
		self
	end

	def to_hash
		{}.merge(self)
	end

end

