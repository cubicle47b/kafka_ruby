require './message'
require './producer'
require './consumer'

class Communications

	# Constructor
	def initialize(id, host, port, producer_topic, consumer_topic, partitions)

		# Set Properties
		@id = id
		@host = host
		@port = port
		@producer_topic = producer_topic
		@consumer_topic = consumer_topic
		@partitions = partitions

		@producer = Producer.new(@id, @host, @port, @producer_topic)
		@consumer = Consumer.new(@id, @host, @port, @consumer_topic, @partitions)

	end

	# Messages
	def send_messages(messages)
		@producer.send_messages(messages)
	end

	def receive_messages()
		return @consumer.read_messages()
	end

end
