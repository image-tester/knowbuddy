class PostsController < ApplicationController
  add_template_helper(PostHelper)
  before_filter :find_post, only: [:destroy, :edit, :remove_tag, :update]

  before_filter :order_by_name_email,
    only: [ :edit, :index, :post_date, :new, :search, :user_posts, :show,
      :create, :related_tag ]

  before_filter :tag_cloud,
    only: [ :edit, :index, :post_date, :new, :related_tag, :search,
      :show, :user_posts, :create, :draft]

  before_filter :user_list,
    only: [ :index, :post_date, :contributors_pagination,
      :related_tag, :show, :user_posts ]

  before_filter :find_activities, only:[:index, :load_activities,
    :load_partials, :create]

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag', full: true

  respond_to :js, only: [:load_activities, :contributors_pagination]

  def create
    attachment = params[:post].delete :attachment
    get_current_post
    respond_to do |format|
      if @post.save
        save_attachments
        load_partials
        format.json { render json: { new_entry: @new_entry,
          activities: @activities_html, sidebar: @sidebar } }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity}
      end
    end
  end

  def draft
    get_current_post
    @post.save(validate: false)
    save_attachments
    render json: { new_post: @post.id }
  end

  def draft_list
    @posts = current_user.posts.draft
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def edit
    remove_orphan_attachments
    edit_post = render_to_string(partial: "editentry",
      locals: {post: @post})
    render json: edit_post.to_json
  end

  def index
    @posts = Post.published.page(params[:page_2]).per(10)
    @post = Post.new(params[:post])
    @attachment = @post.attachments
  end

  def post_date
    @post = Post.find(params[:post_id])
    @posts = Post.post_date(@post)
  end

  def load_partials
    @new_entry = render_to_string(partial: "entries",
      locals: { post: @post })
    @sidebar = render_to_string( partial: "sidebar",
      locals: { tag_cloud_hash: tag_cloud, users: @users})
    @activities_html = render_to_string( partial: "activities",
      locals: { activities: @activities })
  end

  def new
    remove_orphan_attachments
    @post = Post.new
    new_post = render_to_string(partial: "newentry",
      locals: {post: @post})
    render json: { new_post: new_post }
  end

  def parse_content
    @content = RedCloth.new(params[:divcontent]).to_html
    render json: @content.to_json
  end

  def related_tag
    @related_tags = Post.tagged_with(params[:name])
  end

  def remove_tag
    @post.tag_list.remove(params[:tag])
    @post.save
    render json: true
  end

  def save_attachments
    attachments = params[:attachments_field].split(",")
    if attachments.present?
      attachments.each do |attachment|
        @post.attachments << Attachment.find(attachment)
      end
    end
  end

  def search
    @posts_searched = Post.published.search_post(params[:search]) if
      params[:search].present?
  end

  def show
    begin
      find_post
    rescue
      render template: 'posts/post_not_found', status: :not_found
    else
      respond_to do |format|
        format.html
        format.json { render json: @post }
      end
    end
  end

  def update
    attachment = params[:post].delete :attachment
    respond_to do |format|
      if @post.update_attributes(params[:post])
        save_attachments
        update_entry = render_to_string(partial: "post", locals:{post: @post})
        format.json { render json: update_entry.to_json}
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_posts
    @post_user = User.get_user(params[:user_id])
    @posts = @post_user.posts
  end

  protected
    def find_activities
      @activities = Activity.latest_activities(params[:page_3])
    end

    def find_post
      @post = Post.find(params[:id])
    end

    def order_by_name_email
      @users = User.by_name_email.page(params[:page]).per(5)
    end

    def remove_orphan_attachments
      Post.invalid_attachments
    end

    def user_list
      @users = User.with_deleted.page(params[:page]).per(5)
    end

    def tag_cloud
      @posts = Post.published
      @tag_cloud_hash = @posts.tag_cloud
    end

    def get_current_post
      post = params[:post]
      if post[:id].empty?
        @post = Post.new(post)
      else
        @post = Post.find(post[:id])
        @post.assign_attributes(params[:post])
      end
    end
end
