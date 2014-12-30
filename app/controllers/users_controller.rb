class UsersController < ApplicationController
  before_action :find_user

  def update
    respond_to do |format|
      if update_user
        sign_in @user, bypass: true
        format.html { redirect_to posts_path,
          notice: 'Profile updated successfully.' }
        format.json { head :ok }
      else
        format.html { render "edit" }
        format.json { render json: @user.errors,
          status: :unprocessable_entity }
      end
    end
  end

  protected
    def find_user
      @user = User.find(params[:id])
    end

    def skip_password
     user_params.slice!(:password, :password_confirmation, :current_password)
    end

    def password_blank?
      user = user_params
      user[:current_password].blank? && user[:password].blank? &&
        user[:password_confirmation].blank?
    end

    def update_user
      if password_blank?
        @user.update_without_password(skip_password)
      else
        @user.update_with_password(user_params)
      end
    end

  private
    def user_params
      params.require(:user).permit(:email, :name, :current_password,
        :password, :password_confirmation, :remember_me)
    end
end
