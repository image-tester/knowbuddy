class KyuEntriesController < ApplicationController

  before_filter :find_kyu,
    only: [ :destroy, :edit, :remove_tag, :updates ]

  before_filter :order_by_name_email,
    only: [ :edit, :index, :kyu_date, :new, :search, :user_kyu ]

  before_filter :tag_cloud,
    only: [ :edit, :index, :kyu_date, :new, :related_tag, :search,
            :show, :user_kyu  ]

  before_filter :user_list,
    only: [ :index, :kyu_date, :related_tag, :show, :user_kyu ]

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag',
               full: true

  # POST /kyu_entries
  # POST /kyu_entries.json
  def create
    error = []
    attachment = params[:kyu_entry].delete :attachment
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    @kyu_entry.user = current_user
    @kyu_entry.publish_at = Time.now
    respond_to do |format|
      if @kyu_entry.save
        attachment["kyu"].each do |attach|
          begin
            Attachment.create!(kyu: attach, kyu_entry_id: @kyu_entry.id)
          rescue Exception => e
            error << e.inspect
          end
        end unless attachment.blank?
        format.html { redirect_to @kyu_entry,
                      notice: error.blank? ? 'Post was successfully created.' :
                      error.join(",") + " invalid file extension." }
        format.json { render json: @kyu_entry,
                      status: :created, location: @kyu_entry }
      else
        format.html { render 'new' }
        format.json { render json: @kyu_entry.errors,
                      status: :unprocessable_entity }
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
  end

  def index
    @kyu_entries = KyuEntry.page(params[:page])
    respond_to do |format|
      format.html
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
    @kyu_entry = KyuEntry.new
    respond_to do |format|
      format.html
      format.json { render json: @kyu_entry }
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
      @attachment = @kyu_entry.attachments
      @comment = Comment.new
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
        attachment["kyu"].each do |attach|
          begin
            Attachment.create!(kyu: attach, kyu_entry_id: @kyu_entry.id)
          rescue ActiveRecord::RecordInvalid
            error << attach.original_filename
          end
        end unless attachment.blank?
        format.html { redirect_to @kyu_entry,
                      notice: error.blank? ? 'Post was successfully updated.' :
                      error.join(",") + " invalid file extension." }
        format.json { head :ok }
      else
        format.html { render 'edit' }
        format.json { render json: @kyu_entry.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  def user_kyu
    @kyu = KyuEntry.list(params[:user_id])
    @kyu_user = User.get_user(params[:user_id]).first
  end

  protected
    def find_kyu
      @kyu_entry = KyuEntry.find(params[:id])
    end

    def order_by_name_email
      @users = User.by_name_email
    end

    def user_list
      @user = User.with_deleted
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

