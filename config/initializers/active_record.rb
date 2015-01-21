module ActiveRecord
	class Base

    def decrypt(data)
      return '' unless data.present?
      cipher = build_cipher(:decrypt, 'mypassword')
      cipher.update(Base64.urlsafe_decode64(data).unpack('m')[0]) + cipher.final
    end
  
    def encrypt(data)
      return '' unless data.present?
      cipher = build_cipher(:encrypt, 'mypassword')
      Base64.urlsafe_encode64([cipher.update(data) + cipher.final].pack('m'))
    end
  
    def build_cipher(type, password)
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').send(type)
      cipher.pkcs5_keyivgen(password)
      cipher
    end
    
    #ex: @avatar_cache = cache_files(avatar,@avatar_cache,lambda {|f| assign_attributes(avatar: f)})
    def cache_files(avatar,avatar_cache,executar = {})
      if avatar.queued_for_write[:original]
        FileUtils.cp(avatar.queued_for_write[:original].path, avatar.path(:original))
        avatar_cache = encrypt(avatar.path(:original))
      elsif avatar_cache.present?
        File.open(decrypt(avatar_cache)) {|f| executar.call(f) }
      end
      return avatar_cache
    end
    
	end
end
