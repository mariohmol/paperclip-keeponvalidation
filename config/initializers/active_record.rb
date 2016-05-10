module ActiveRecord
  class Base
    def associate_nested_form_attribute attribute, data, attr_class, validate_expr='true'
      attr_class = attr_class.to_s.camelize.constantize
      if self.respond_to? attribute
        self.send(attribute).clear
        data.map do |k, s|
          self.send(attribute).build(s) if !s[:_destroy].to_bool and eval("#{validate_expr}")
        end unless data.blank?
      end
    end

    def reload_nested_form_attributes attrs=[]
      attrs.each { |att| self.send(att).build if self.send(att).blank? }
    end
    
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


    #ex: @avatar_cache = cache_files(avatar,@avatar_cache,lambda {|f| assign_attributes("avatar" => f)})
    def cache_file(avatar,avatar_cache,executar = {})
      destination=nil
      destination=avatar.path(:original) if avatar.is_a? Paperclip::Attachment
      cache_file_destination(avatar,avatar_cache,executar,destination)
    end    
    
    #ex: @avatar_cache = cache_files(avatar,@avatar_cache,lambda {|f| assign_attributes("avatar" => f)},Rails.root.join('public',"system/projetos/original/"))
    def cache_file_destination(avatar,avatar_cache,executar = {},destination)
      destination=destination.to_s if destination.is_a? Pathname
     
      if destination and not File.directory?(destination)
        dirname = File.dirname(destination)
        FileUtils::mkdir_p dirname 
      end
      
      if destination and avatar.is_a? Paperclip::Attachment and avatar.queued_for_write[:original]
        FileUtils.cp(avatar.queued_for_write[:original].path, destination)
        FileUtils.chmod(0755,destination)
        avatar_cache = encrypt(destination)
      elsif destination and avatar.is_a? ActionDispatch::Http::UploadedFile and avatar.tempfile
        FileUtils.cp(avatar.tempfile.path, destination)
        FileUtils.chmod(0755,destination)
        avatar_cache = encrypt(destination)
      elsif avatar_cache.present?
        begin
          File.open(decrypt(avatar_cache)) {|f| executar.call(f) }
         rescue
          puts "could not get the cache file"  
         end
      end
      return avatar_cache
    end
    
    def human_attribute_name(attr,options={})
      begin
        HUMANIZED_ATTRIBUTES[attr.to_sym] || attr.humanize
      rescue
        ""
      end
      
    end
    
  end
end
