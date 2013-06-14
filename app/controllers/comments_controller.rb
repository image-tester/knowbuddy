class CommentsController < ApplicationController

  before_filter :find_comment, only: [:destroy, :edit, :show, :update]

  def create
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
    @comment = @kyu_entry.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        #send email notifications to everyone
        new_comment = render_to_string(partial: "comment",
          locals: {comment: @comment, kyu_entry: @comment.kyu_entry})
        format.json { render json: new_comment.to_json }
      end
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

  def edit
  end

  def index
    @kyu_entry = KyuEntry.find(comment.kyu_entry_id)
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

  def user_comment
    @comments = Comment.list
    # User = Active + Inactive(Deleted)
    @user = User.with_deleted.where("id = ?", params[:id]).first
  end

    protected
    def find_comment
      @comment = Comment.find(params[:id])
    end
end


