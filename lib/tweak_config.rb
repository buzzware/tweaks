class TweakConfig < Hash

	attr_reader :default_values

	def initialize(aDefaultValues,aNewValues=nil,&aBlock)
		@default_values = aDefaultValues.clone
		reset()
		if aNewValues
			block_given? ? read(aNewValues,&aBlock) : read(aNewValues) 
		end
	end

	# aBlock allows values to be filtered based on key,default and new values
	def read(aSource,&aBlock)
		default_values.each do |k,v|
			done = false
			if block_given? && ((newv = yield(k,v,aSource && aSource[k])) != nil)
				self[k] = newv
				done = true
			end
			copy_item(aSource,k) if !done && aSource && !aSource[k].nil?
		end
		self
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
			when :NilClass then ;
			when :String then self[aKey] = aHash[aKey].to_s unless aHash[aKey].nil?
			when :Float then set_float(aKey,aHash[aKey]);
			when :Fixnum then set_int(aKey,aHash[aKey]);
			when :TrueClass, :FalseClass then set_boolean(aKey,aHash[aKey]);
			when :Symbol then self[aKey] = (aHash[aKey].to_sym rescue nil)
			when :Proc then self[aKey] = aHash[aKey] if aHash[aKey].is_a?(Proc)
			else
				raise StandardError.new('unsupported type')
		end
	end

	def copy_strings(aHash,*aKeys)
		aKeys.each do |k|
			self[k] = aHash[k].to_s unless aHash[k].nil?
		end
	end

	def copy_ints(*aDb)
		aHash = aDb.shift
		aKeys = aDb
		aKeys.each do |k|
			set_int(k,aHash[k])
		end
	end

	def copy_floats(aHash,*aKeys)
		aKeys.each do |k|
			set_float(k,aHash[k])
		end
	end

	def copy_booleans(aHash,*aKeys)
		aKeys.each do |k|
			set_boolean(k,aHash[k])
		end
	end

	def to_hash
		{}.merge(self)
	end

end

