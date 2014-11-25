require 'mysql2'

class Database

	private
	def query(sql)
		begin
			client = Mysql2::Client.new(host:'localhost', username:'kafka_user', password:'kafka_user', database:'kafka')
			results = client.query(sql, symbolize_keys: true)	
		rescue Mysql2::Error => e
			puts e.error
		ensure
			client.close
		end
		return results
	end

	public
	
	# Users
	def users()
		return query("SELECT * FROM Users")
	end

	def get_user_by_id(id)
		return query("SELECT * FROM Users WHERE Id = #{id}")
	end

	# Medical records
	def medical_records()
		return query("SELECT * FROM MedicalRecords")
	end

	def get_medical_record_by_id(id)
		return query("SELECT * FROM MedicalRecords WHERE Id = #{id}")
	end

	def get_medical_record_by_name(last_name, first_name)
		return query("SELECT * FROM MedicalRecords WHERE LastName = '#{last_name}' AND FirstName = '#{first_name}'")
	end

	# Files
	def get_files()
		return query("SELECT * FROM Files")
	end

	def get_files_by_id(id)
		return query("SELECT * FROM Files WHERE Id = #{id}")
	end

end
