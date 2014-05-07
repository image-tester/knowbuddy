class CommentsController < ApplicationController

  before_filter :find_comment, only: [:destroy, :edit, :show, :update]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    if @comment.save
      new_comment = render_to_string(partial: "comment",
        locals: {comment: @comment, post: @comment.post})
      render json: { new_comment: new_comment }
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment.destroy
    respond_to do |format|
     format.html { redirect_to @post }
     format.js
    end
  end

  def index
    @post = comment.post
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
        format.html { redirect_to @comment.post,
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
