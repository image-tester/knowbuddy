class KyuEntriesController < ApplicationController

  before_filter :find_kyu,
    only: [ :destroy, :edit, :remove_tag, :update ]

  before_filter :order_by_name_email,
    only: [ :edit, :index, :kyu_date, :new, :search, :user_kyu, :show, :create,
            :related_tag ]

  before_filter :tag_cloud,
    only: [ :edit, :index, :kyu_date, :new, :related_tag, :search,
            :show, :user_kyu, :create]

  before_filter :user_list,
    only: [ :index, :kyu_date, :related_tag, :show, :user_kyu ]

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag',
               full: true

  # POST /kyu_entries
  # POST /kyu_entries.json

  def create
    attachment = params[:kyu_entry].delete :attachment
    params[:kyu_entry].merge!(user_id: current_user.id)
    params[:kyu_entry].merge!(publish_at: Time.now)
    kyu_entry = KyuEntry.new(params[:kyu_entry])
    # kyu_entry.set_user_and_publish_date(current_user)
    respond_to do |format|
      if kyu_entry.save
        attachments = params[:attachments_field].split(",")
        unless attachments.blank?
          attachments.each do |attachment|
            kyu_entry.attachments << Attachment.find(attachment)
          end
        end
        @activities = Activity.joins(:activity_type)
                      .where("activity_types.is_active" => 1)
                      .order("created_at desc").page(params[:page_3]).per(20)
        new_entry = render_to_string(partial: "entries",
                    locals: { kyu_entry: kyu_entry })
        sidebar = render_to_string( partial: "sidebar",
                    locals: { tag_cloud_hash: tag_cloud, users: @users})
        activity = render_to_string( partial: "activities")
        format.json { render json: { new_entry: new_entry, sidebar: sidebar,
                    activity: activity } }
      else
        format.json { render json: kyu_entry.errors,
                    status: :unprocessable_entity}
      end
    end
  end

  # DELETE /kyu_entries/1
  # DELETE /kyu_entries/1.json
  def destroy
    @kyu_entry.destroy
    respond_to do |format|
      format.html { redirect_to kyu_entries_url }
      format.json { head :ok }
    end
  end

  # GET /kyu_entries/1/edit
  def edit
    @kyu_entry = KyuEntry.find(params[:id])
    edit_kyu = render_to_string(partial: "editentry",
               locals: {kyu_entry: @kyu_entry})
    respond_to do |format|
      format.json { render json: edit_kyu.to_json }
    end
  end
  def index
    @kyu_entries = KyuEntry.page(params[:page_2])
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    @activities = Activity.joins(:activity_type)
                  .where("activity_types.is_active" => 1)
                  .order("created_at desc").page(params[:page_3]).per(20)
    @attachment = @kyu_entry.attachments
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @kyu_entries }
    end
  end

  def kyu_date
    @kyu_entry = KyuEntry.find(params[:kyu_id])
    start_date = @kyu_entry.created_at.to_date.beginning_of_day
    end_date = @kyu_entry.created_at.to_date.end_of_day
    @kyu = KyuEntry.post_date(start_date, end_date)
  end

  # GET /kyu_entries/new
  # GET /kyu_entries/new.json
  def new
    KyuEntry.invalid_attachments
    @kyu_entry = KyuEntry.new
    new_kyu = render_to_string(partial: "newentry",
              locals: {kyu_entry: @kyu_entry})
    respond_to do |format|
      format.json { render json: new_kyu.to_json }
    end
  end

  def parse_content
    @content = RedCloth.new(params[:divcontent]).to_html
    render json: @content.to_json
  end

  def related_tag
   @related_tags = KyuEntry.tagged_with(params[:name])
  end

  # Added on 23rd April 2012 by yatish to delete tags
  # Start
  def remove_tag
    @kyu_entry.tag_list.remove(params[:tag])
    @kyu_entry.save
    render json: true
  end
  # End

  # GET /kyu_entries/1
  # GET /kyu_entries/1.json
  def search
    unless params[:search].blank?
      @search = Sunspot.search(KyuEntry) do
        fulltext params[:search]
      end
      @kyu = @search.results
    end
  end

  def show
    begin
      @kyu_entry = KyuEntry.find(params[:id])
    rescue
      render template: 'kyu_entries/kyu_not_found', status: :not_found
    else
      respond_to do |format|
        format.html
        format.json { render json: @kyu_entry }
      end
    end
  end

  # PUT /kyu_entries/1
  # PUT /kyu_entries/1.json
  def update
    error = []
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
    @kyu = KyuEntry.list(params[:user_id])
    @kyu_user = User.get_user(params[:user_id]).first
    respond_to do |format|
      format.html
      format.js { render :index }
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

  # This is default value for textArea value of KYU entry
  # This is done so that users will be able to quickly know
  # that the content text is enabled with textile markup
  # so that they can use textile
  $text_area_default_value = 'h1. This is Textile markup. Give it a try!

  A *simple* paragraph with
  a line break, some _emphasis_ and a "link":http://redcloth.org

  * an item
  * and another

  # one
  # two
  '
end