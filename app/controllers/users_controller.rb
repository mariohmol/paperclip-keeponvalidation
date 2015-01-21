#encoding: utf-8
class UsersController < ApplicationController

    def save_user
        @empreendedor.logo_cache = params[:user][:logo_cache]
        @empreendedor.cache_images
        @empreendedor.save
    end

end
