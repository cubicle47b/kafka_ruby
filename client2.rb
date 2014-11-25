require './client'

client = Client.new("Client2", [0,1])

client.run_detailed_medical_request("Leyden", "David")
client.run_detailed_medical_request("Brown", "Jordan")
