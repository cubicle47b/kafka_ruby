require 'openssl'

def encrypt(input)
	cipher = OpenSSL::Cipher::Cipher.new("DES-EDE3-CBC")
	cipher.encrypt
	cipher.pkcs5_keyivgen("All the King's Horses and all the King's men")
	output = cipher.update(input) + cipher.final
	return output
end

def decrypt(input)
	cipher = OpenSSL::Cipher::Cipher.new("DES-EDE3-CBC")
	cipher.decrypt
	cipher.pkcs5_keyivgen("All the King's Horses and all the King's men")
	output = cipher.update(input) + cipher.final
	return output
end
