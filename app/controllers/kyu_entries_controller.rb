class KyuEntriesController < ApplicationController

  ACTIVITIES_PER_PAGE = 20

  before_filter :find_kyu,
    only: [ :destroy, :edit, :remove_tag, :update ]

  before_filter :order_by_name_email,
    only: [ :edit, :index, :kyu_date, :new, :search, :user_kyu, :show,
      :create, :related_tag ]

  before_filter :tag_cloud,
    only: [ :edit, :index, :kyu_date, :new, :related_tag, :search,
      :show, :user_kyu, :create]

  before_filter :user_list,
    only: [ :index, :kyu_date, :related_tag, :show, :user_kyu ]

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag', full: true

  def create
    attachment = params[:kyu_entry].delete :attachment
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    respond_to do |format|
      if @kyu_entry.save
        save_attachments
        load_partials
        format.json { render json: { new_entry: @new_entry, sidebar: @sidebar,
          activity: @activity } }
      else
        format.json { render json: @kyu_entry.errors,
          status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @kyu_entry.destroy
    respond_to do |format|
      format.html { redirect_to kyu_entries_url }
      format.json { head :ok }
    end
  end

  def edit
    edit_kyu = render_to_string(partial: "editentry",
      locals: {kyu_entry: @kyu_entry})
    render json: edit_kyu.to_json
  end

  def index
    @kyu_entries = KyuEntry.page(params[:page_2])
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    @activities = Activity.latest_activities(params[:page_3])
    @attachment = @kyu_entry.attachments
    if request.xhr?
      params[:page_3].present? ? load_activities :
        (render :render_contributors_pagination)
    end
  end

  def load_activities
    hide_link = true if @activities.count < ACTIVITIES_PER_PAGE
    activities = render_to_string(partial: 'kyu_entries/activities')
    render json: { activities: activities, hide_link: hide_link }
  end

  def kyu_date
    @kyu_entry = KyuEntry.find(params[:kyu_id])
    @kyu = KyuEntry.post_date(@kyu_entry)
  end

  def load_partials
    @activities = Activity.latest_activities(params[:page_3])
    @new_entry = render_to_string(partial: "entries",
      locals: { kyu_entry: @kyu_entry })
    @sidebar = render_to_string( partial: "sidebar",
      locals: { tag_cloud_hash: tag_cloud, users: @users})
    @activity = render_to_string( partial: "activities")
  end

  def new
    KyuEntry.invalid_attachments
    @kyu_entry = KyuEntry.new
    new_kyu = render_to_string(partial: "newentry",
      locals: {kyu_entry: @kyu_entry})
    render json: { new_kyu: new_kyu }
  end

  def parse_content
    @content = RedCloth.new(params[:divcontent]).to_html
    render json: @content.to_json
  end

  def related_tag
    @related_tags = KyuEntry.tagged_with(params[:name])
    respond_to do |format|
      format.html
      format.js {render :render_contributors_pagination}
    end
  end

  def render_contributors_pagination
    respond_to do |format|
      format.js
    end
  end

  def remove_tag
    @kyu_entry.tag_list.remove(params[:tag])
    @kyu_entry.save
    render json: true
  end

  def save_attachments
    attachments = params[:attachments_field].split(",")
    unless attachments.blank?
      attachments.each do |attachment|
        @kyu_entry.attachments << Attachment.find(attachment)
      end
    end
  end

  def search
    unless params[:search].blank?
      @kyus_searched = KyuEntry.search_kyu(params[:search])
      respond_to do |format|
        format.html
        format.js {render :render_contributors_pagination}
        format.json { render json: @kyus_searched }
      end
    end
  end

  def show
    begin
      find_kyu
    rescue
      render template: 'kyu_entries/kyu_not_found', status: :not_found
    else
      respond_to do |format|
        format.html
        format.json { render json: @kyu_entry }
      end
    end
  end

  def update
    attachment = params[:kyu_entry].delete :attachment
    respond_to do |format|
      if @kyu_entry.update_attributes(params[:kyu_entry])
        update_entry = render_to_string(partial: "kyu_entry",
          locals:{kyu_entry: @kyu_entry})
        format.json { render json: update_entry.to_json}
      else
        format.json { render json: @kyu_entry.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def user_kyu
    @kyu_user = User.get_user(params[:user_id])
    @kyu = @kyu_user.kyu_entries
    respond_to do |format|
      format.html
      format.js {render :render_contributors_pagination}
    end
  end

  protected
    def find_kyu
      @kyu_entry = KyuEntry.find(params[:id])
    end

    def order_by_name_email
      @users = User.by_name_email.page(params[:page]).per(5)
    end

    def user_list
      @user = User.with_deleted
    end

    def tag_cloud
      @tag_cloud_hash = KyuEntry.tag_cloud
    end
end
