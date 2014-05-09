class UsersController < ApplicationController
  before_filter :find_user

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
      params[:user] = params[:user].
        slice!(:password, :password_confirmation, :current_password)
    end

    def password_blank?
      user = params[:user]
      user[:current_password].blank? && user[:password].blank? &&
        user[:password_confirmation].blank?
    end

    def update_user
      if password_blank?
        skip_password
        @user.update_without_password(params[:user])
      else
        @user.update_with_password(params[:user])
      end
    end
end
