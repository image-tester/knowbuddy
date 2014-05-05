class UsersController < ApplicationController
  before_filter :find_user

  def update
    respond_to do |format|
      if @user.update_with_password(params[:user])
        sign_in @user, bypass: true
        format.html { redirect_to kyu_entries_path,
          notice: 'Password was successfully updated.' }
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
end