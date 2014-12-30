class CommentsController < ApplicationController

  before_action :find_comment, only: [:destroy, :edit, :show, :new, :update]
  before_action :find_post, only: [:create, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
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

  def new
    redirect_comment
  end

  def show
    redirect_comment
  end

  def update
      if @comment.update(comment_params)
        redirect_to @comment.post, format: "html",
          notice: "Comment was successfully updated."
      else
        render "edit", format: :html
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
      @post = Post.friendly.find(params[:post_id])
    end

    def redirect_comment
      respond_to do |format|
        format.html
        format.json { render json: @comment }
      end
    end

    def comment_params
      params.require(:comment).permit(:comment, :created_at, :post_id,
        :updated_at, :user_id)
    end
end
