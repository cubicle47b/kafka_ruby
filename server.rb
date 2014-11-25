require './communications'
require './database'

class Server

	# Constructor
	def initialize(id, partitions)
		@communications = Communications.new(id, "localhost", 9092, "client_queue", "server_queue", partitions)
		@database = Database.new()
	end

	# Run Server
	def run()

		# Loop
		loop do

			# Get Requests
			messages = @communications.receive_messages()

			# Handle Requests
			messages.each do |m|
				puts "Received: #{m.get_hash()}"
				reply = handle_request(m)
				@communications.send_messages([reply])
				puts "Sent: #{reply.get_hash()}"
				puts
			end

		end

	end

	# Requests
	def handle_request(message)

		# Handle Request
		case (message.request_type)
			when :simple_medical
				return handle_simple_medical_request(message)
			when :detailed_medical
				return handle_detailed_medical_request(message)
			when :file
				return handle_file_request(message)
		end

	end

	def handle_simple_medical_request(message)
	
		# Get Answer
		row = @database.get_medical_record_by_name(message.parameter1, message.parameter2).first

		# Create Reply
		reply = SimpleMedicalMessage.new()
		reply.to = message.from
		reply.last_name = row[:LastName]
		reply.first_name = row[:FirstName]
		reply.alive = row[:Alive] == "\x01" ? true : false
		return reply

	end

	def handle_detailed_medical_request(message)

		# Get Answer
		row = @database.get_medical_record_by_name(message.parameter1, message.parameter2).first

		# Create Reply
		reply = DetailedMedicalMessage.new()
		reply.to = message.from
		reply.last_name = row[:LastName]
		reply.first_name = row[:FirstName]
		reply.city = row[:City]
		reply.state = row[:State]
		reply.zip_code = row[:ZipCode]
		reply.age = row[:Age]
		reply.alive = row[:Alive] == "\x01" ? true : false
		return reply

	end

	def handle_file_request(message)

		# Get Answer
		row = @database.get_files_by_id(message.parameter1).first

		# Create Reply
		reply = FileMessage.new()
		reply.to = message.from
		reply.filename = row[:Filename]
		reply.file = row[:File]
		return reply

	end

end
