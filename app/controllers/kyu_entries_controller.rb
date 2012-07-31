class KyuEntriesController < ApplicationController
  # GET /kyu_entries
  # GET /kyu_entries.json
  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag',
               full: true
  # POST /kyu_entries
  # POST /kyu_entries.json
  def create
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    @kyu_entry.user = current_user
    @kyu_entry.publish_at = Time.now
    respond_to do |format|
      if @kyu_entry.save
        format.html { redirect_to @kyu_entry,
                      notice: 'KYU was successfully created.' }
        format.json { render json: @kyu_entry,
                      status: :created, location: @kyu_entry }

        #send email notifications to everyone

      else
        format.html { render action: "new" }
        format.json { render json: @kyu_entry.errors,
                      status: :unprocessable_entity }
      end
    end
  end
  # DELETE /kyu_entries/1
  # DELETE /kyu_entries/1.json
  def destroy
    @kyu_entry = KyuEntry.find(params[:id])
    @kyu_entry.destroy
    respond_to do |format|
      format.html { redirect_to kyu_entries_url }
      format.json { head :ok }
    end
  end
  # GET /kyu_entries/1/edit
  def edit
    @kyu_entry = KyuEntry.find(params[:id])
    @list = tag_cloud
  end
  def index
    @user = User.with_deleted
    @kyu_entries = KyuEntry.order('created_at DESC').page(params[:page])
    @list = tag_cloud
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kyu_entries }
    end
  end
  # GET /kyu_entries/new
  # GET /kyu_entries/new.json
  def new
    @kyu_entry = KyuEntry.new
    @list = tag_cloud
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kyu_entry }
    end
  end
  def related_tag
   @related_tags = KyuEntry.tagged_with(params[:name])
   @list = tag_cloud
  end
  # Added on 23rd April 2012 by yatish to delete tags
  # Start
  def remove_tag
    @kyu_entry = KyuEntry.find(params[:id])
    @kyu_entry.tag_list.remove(params[:tag])
    @kyu_entry.save
    render json: true
  end
  # End
  # GET /kyu_entries/1
  # GET /kyu_entries/1.json
  def show
    @user = User.with_deleted
    @kyu_entry = KyuEntry.find(params[:id])
    @comment = Comment.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kyu_entry }
    end
  end
  def search
    @list = tag_cloud
    unless params[:search].blank?
      @search = Sunspot.search(KyuEntry) do
        fulltext params[:search]
      end
      @kyu = @search.results
    end
  end
  # PUT /kyu_entries/1
  # PUT /kyu_entries/1.json
  def update
    @kyu_entry = KyuEntry.find(params[:id])
    respond_to do |format|
      if @kyu_entry.update_attributes(params[:kyu_entry])
        format.html { redirect_to @kyu_entry,
                      notice: 'KYU was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @kyu_entry.errors,
                      status: :unprocessable_entity }
      end
    end
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

