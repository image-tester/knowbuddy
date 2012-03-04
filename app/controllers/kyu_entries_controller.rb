class KyuEntriesController < ApplicationController
  # GET /kyu_entries
  # GET /kyu_entries.json
  
  def index
    @kyu_entries = KyuEntry.order('created_at DESC').page(params[:page])    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kyu_entries }
    end
  end

  # GET /kyu_entries/1
  # GET /kyu_entries/1.json
  def show
    @kyu_entry = KyuEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kyu_entry }
    end
  end

  # GET /kyu_entries/new
  # GET /kyu_entries/new.json
  def new
    @kyu_entry = KyuEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kyu_entry }
    end
  end

  # GET /kyu_entries/1/edit
  def edit
    @kyu_entry = KyuEntry.find(params[:id])
  end

  # POST /kyu_entries
  # POST /kyu_entries.json
  def create
    @kyu_entry = KyuEntry.new(params[:kyu_entry])
    @kyu_entry.user = current_user
    
    respond_to do |format|
      if @kyu_entry.save
        format.html { redirect_to @kyu_entry, notice: 'KYU was successfully created.' }
        format.json { render json: @kyu_entry, status: :created, location: @kyu_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @kyu_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kyu_entries/1
  # PUT /kyu_entries/1.json
  def update
    @kyu_entry = KyuEntry.find(params[:id])

    respond_to do |format|
      if @kyu_entry.update_attributes(params[:kyu_entry])
        format.html { redirect_to @kyu_entry, notice: 'KYU was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @kyu_entry.errors, status: :unprocessable_entity }
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
end
