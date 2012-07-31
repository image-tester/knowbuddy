class CommentsController < ApplicationController
  def create
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
    @comment = @kyu_entry.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@kyu_entry,
                      notice: 'Comment was successfully created.') }
          #send email notifications to everyone
      else
        format.html { redirect_to(@kyu_entry,
          notice: 'Comment could not be saved. Please fill in all fields')}
      end
    end
  end
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end
  def new
    @comment = Comment.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end
  def edit
    @comment = Comment.find(params[:id])
  end
  def update
    @comment = Comment.find(params[:id])
    @kyu_entry = @comment.kyu_entry
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @kyu_entry,
                      notice: 'Comment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  def destroy
  @comment = Comment.find(params[:id])
  @kyu_entry = KyuEntry.find(params[:kyu_entry_id])
  @comment.destroy
    respond_to do |format|
     format.html { redirect_to @kyu_entry }
    end
  end
end

