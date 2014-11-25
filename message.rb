require 'json'
require 'base64'
require './cipher'

# Factory
class MessageFactory

	def self.create_message(options = {})

		# Get Hash, Type
		if (options.has_key?(:json)) then
			hash = symbolize(JSON.parse(decrypt(options[:json]), symbolize_names: true))
			type = hash[:type]
		elsif (options.has_key?(:type)) then
			hash = Hash.new
			type = options[:type]
		end

		# Create Message
		case (type)
			when :request
				return RequestMessage.new(hash)
			when :simple_medical
				return SimpleMedicalMessage.new(hash)
			when :detailed_medical
				return DetailedMedicalMessage.new(hash)
			when :file
				return FileMessage.new(hash)			
		end

	end

	def self.symbolize(hash)
		[:type, :request_type].each do |s|
			if (hash.has_key?(s)) then
				hash[s] = hash[s].to_sym
			end
		end
		return hash
	end

end

# Base Class
class Message

	# Properties
	def type
		@hash[:type]
	end

	def to
		@hash[:to]
	end
	def to=(value)
		@hash[:to] = value
	end

	def to?
		@hash.has_key?(:to)
	end

	def from
		@hash[:from]
	end
	def from=(value)
		@hash[:from] = value
	end

	# Constructor
	def initialize(hash)
		@hash = hash
	end

	# Hash
	def get_hash()
		return @hash
	end

	# JSON
	def to_encrypted_json()
		return encrypt(@hash.to_json())
	end

end

# Message Types
# Request
class RequestMessage < Message

	# Properties
	def request_type
		@hash[:request_type]
	end
	def request_type=(value)
		@hash[:request_type] = value	
	end

	def parameter1
		@hash[:parameter1]
	end
	def parameter1=(value)
		@hash[:parameter1] = value
	end

	def parameter2
		@hash[:parameter2]
	end
	def parameter2=(value)
		@hash[:parameter2] = value
	end

	# Constructor
	def initialize(hash = {})
		super(hash)
		hash[:type] = :request
	end

end

# Simple Medical Record
class SimpleMedicalMessage < Message

	# Properties
	def last_name
		@hash[:last_name]
	end
	def last_name=(value)
		@hash[:last_name] = value	
	end

	def first_name
		@hash[:first_name]
	end
	def first_name=(value)
		@hash[:first_name] = value
	end

	def alive
		@hash[:alive]
	end
	def alive=(value)
		@hash[:alive] = value	
	end

	# Constructor
	def initialize(hash = {})
		super(hash)
		hash[:type] = :simple_medical
	end

end

# Detailed Medical Record
class DetailedMedicalMessage < Message

	# Properties
	def last_name
		@hash[:last_name]
	end
	def last_name=(value)
		@hash[:last_name] = value	
	end

	def first_name
		@hash[:first_name]
	end
	def first_name=(value)
		@hash[:first_name] = value
	end

	def city
		@hash[:city]
	end
	def city=(value)
		@hash[:city] = value
	end

	def state
		@hash[:state]	
	end
	def state=(value)
		@hash[:state] = value
	end

	def zip_code
		@hash[:zip_code]
	end
	def zip_code=(value)
		@hash[:zip_code] = value	
	end

	def age
		@hash[:age]
	end
	def age=(value)
		@hash[:age] = value
	end

	def alive
		@hash[:alive]
	end
	def alive=(value)
		@hash[:alive] = value	
	end

	# Constructor
	def initialize(hash = {})
		super(hash)
		hash[:type] = :detailed_medical
	end

end

# File
class FileMessage < Message

	# Properties
	def filename
		@hash[:filename]
	end
	def filename=(value)
		@hash[:filename] = value	
	end

	def file
		@hash[:file]
	end
	def file=(value)
		@hash[:file] = value
	end

	# Constructor
	def initialize(hash = {})
		super(hash)
		hash[:type] = :file
		hash[:file] = Base64.decode64(hash[:file])
	end

	# JSON
	def to_encrypted_json()
		hash = @hash.clone
		hash[:file] = Base64.encode64(hash[:file])
		return encrypt(hash.to_json())
	end

end
