class CommentsController < ApplicationController

  before_filter :find_comment, only: [:destroy, :edit, :show, :new, :update]
  before_filter :find_post, only: [:create, :destroy]
  after_filter :comment_redirect, only: [:new, :show]

  def create
    @comment = @post.comments.build(params[:comment])
    if @comment.save
      new_comment = render_to_string(partial: "comment",
        locals: {comment: @comment, post: @comment.post})
      render json: { new_comment: new_comment }
    end
  end

  def destroy
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
  end

  def show
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
    @user = User.get_user(params[:id])
    @comments = @user.comments
  end

  protected
    def find_comment
      @comment ||= params[:id] ? Comment.find(params[:id]) : Comment.new
    end

    def find_post
      @post = Post.find(params[:post_id])
    end

    def comment_redirect
      respond_to do |format|
        format.html
        format.json { render json: @comment }
      end
    end

end
