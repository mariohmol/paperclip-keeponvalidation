# encoding: utf-8
class User < ActiveRecord::Base
 
  has_attached_file :logo, PaperclipUtils.config
  attr_accessor :logo_cache
  def cache_images
    @logo_cache=cache_files(logo,@logo_cache, lambda {|f| assign_attributes(logo: f)})
  end

end
