class CommentsController < ApplicationController

  before_filter :find_comment, only: [:edit, :update, :destroy, :show]

  def create
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
    @comment = @kyu_entry.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@kyu_entry,
                      notice: 'Comment was successfully created.') }
          #send email notifications to everyone
      else
        format.html { redirect_to(@kyu_entry,
          notice: 'Comment could not be saved. Please fill in all fields')}
      end
    end
  end

  def destroy
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
  @comment.destroy
    respond_to do |format|
     format.html { redirect_to @kyu_entry }
    end
  end

  def edit
  end

  def new
    @comment = Comment.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # display all comments of a particular user
  def user_comment
    @comments = Comment.find(:all, conditions: {user_id: params[:id]})
    # User = Active + Inactive(Deleted)
    @user = User.with_deleted.where("id = ?", params[:id]).first
  end

  def update
    @kyu_entry = @comment.kyu_entry
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @kyu_entry,
                      notice: 'Comment was successfully updated.' }
      else
        format.html { render 'edit' }
      end
    end
  end

  protected
    def find_comment
      @comment = Comment.find(params[:id])
    end
end

