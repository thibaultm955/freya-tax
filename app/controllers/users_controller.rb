class UsersController < ApplicationController

    def index

    end

    def show
        @user = User.find(current_user.id)
        @languages = Language.all
    end

    def update
        @user = User.find(current_user.id)
        @user.update(email: params[:user][:email], language_id: params[:language].to_i)
        redirect_to root_path
    end

end