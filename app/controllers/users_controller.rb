class UsersController < ApplicationController

  def edit
   @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_with_password(params[:user])
        sign_in @user, bypass: true
        params[:user][:password]?
          format.html { redirect_to kyu_entries_path,
                      notice: 'Password was successfully updated.' } :
          format.html { redirect_to kyu_entries_path,
                      notice: 'Profile was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render 'edit' }
        format.json { render json: @user.errors,
                      status: :unprocessable_entity }
      end
    end
  end
end

