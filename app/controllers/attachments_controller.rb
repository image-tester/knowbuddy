class AttachmentsController < ApplicationController

  before_action :find_attachment, only: [:create]

  def create
    respond_to do |format|
      byebug
      if @attachment.save
        format.json {
          attachment = render_to_string(
            partial: "posts/attachments.html.haml",
            locals: { a: @attachment })
          render json: { attachment: attachment, id: @attachment.id }
        }
      else
        format.html { render 'new' }
        format.json { render json: @attachment.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
    byebug
    attachment = Attachment.find params[:id]
    attachment.destroy
    render json: true
  end

  private
    def find_attachment
      # debugger
      attachment = params[:files].first
      @attachment = Attachment.create(post: attachment)
    end

    def attachment_params
      params.require(:attachment).permit(:post_id, :created_at, :updated_at, :post)
    end
end
