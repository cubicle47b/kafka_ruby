require './client'

client = Client.new("Client1", [0,1])

client.run_simple_medical_request("Leyden", "David")
client.run_simple_medical_request("Brown", "Jordan")
