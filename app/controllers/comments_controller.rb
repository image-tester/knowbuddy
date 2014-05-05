class CommentsController < ApplicationController

  before_filter :find_comment, only: [:destroy, :edit, :show, :update]

  def create
    @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
    @comment = @kyu_entry.comments.build(params[:comment])
    if @comment.save
      new_comment = render_to_string(partial: "comment",
        locals: {comment: @comment, kyu_entry: @comment.kyu_entry})
      render json: { new_comment: new_comment }
    end
  end

  def destroy
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
  @comment.destroy
    respond_to do |format|
     format.html { redirect_to @kyu_entry }
     format.js
    end
  end

  def index
    @kyu_entry = comment.kyu_entry
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

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.kyu_entry,
          notice: 'Comment was successfully updated.' }
      else
        format.html { render 'edit' }
      end
    end
  end

  def user_comment
    @user = User.get_user(user_id)
    @comments = @user.comments
  end

  protected
    def find_comment
      @comment = Comment.find(params[:id])
    end
end
