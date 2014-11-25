require 'poseidon'
require './message'

class Producer

	# Constructor
	def initialize(id, host, port, topic)

		# Set Properties
		@id = id
		@host = host
		@port = port
		@topic = topic

		@producer = Poseidon::Producer.new([@host + ":" + @port.to_s()], @id, :type=>:sync, :compression_codec=>:gzip)
	
	end

	# Messages
	def send_messages(messages)
		poseidon_messages = []
		messages.each do |m|
			m.from = @id
			poseidon_messages << Poseidon::MessageToSend.new(@topic, m.to_encrypted_json())
		end
		@producer.send_messages(poseidon_messages)
	end

end
