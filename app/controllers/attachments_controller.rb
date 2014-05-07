class AttachmentsController < ApplicationController

  def create
    attachment = params[:files].first
    @attachment = Attachment.create(post: attachment)
    render_output(@attachment)
  end

  def update
    attachment = params[:files].first
    @attachment = Attachment.create(post: attachment)
    @attachment.post_id = params[:post_id]
    render_output(@attachment)
  end

  def destroy
    attachment = Attachment.find params[:id]
    attachment.destroy
    render json: true
  end

  def render_output(attach)
    respond_to do |format|
      if attach.save
        format.json {
          attachment = render_to_string(
            partial: "posts/attachments.html.haml",
            locals: { a: attach })
          render json: { attachment: attachment, id: attach.id }
        }
      else
        format.html { render 'new' }
        format.json { render json: attach.errors,
          status: :unprocessable_entity }
      end
    end
  end
end
