class AttachmentsController < ApplicationController
  load_and_authorize_resource

  def serve_doc
    public_images_path = File.join(Rails.root,"public","site_images")
    image_path = File.join(public_images_path,"no_doc_thumb.jpg")
    base_path = File.join( Rails.root,
                            "dynamic_files",
                            Rails.env,
                            "attachment",
                            "doc",
                            @attachment.id.to_s
                          )

    unless @attachment.doc_identifier.blank?

      if params[:type] == Attachment::THUMB
        if @attachment.is_image?
          image_path = File.join(base_path,"#{params[:type]}_#{@attachment.doc_identifier}")
        else # thumbnail for other file types. Eaxmple: .txt, .doc, .pdf, etc ...
          image_path = File.join(public_images_path,"doc_thumb.png")
        end
      elsif params[:type] == Attachment::DOC
        image_path = File.join(base_path,@attachment.doc_identifier)
      end
    end

    unless send_file( image_path, disposition: 'inline', x_sendfile: true )
      # Next line should never be reached, failsafe.
      send_file( File.join(public_images_path,"no_doc_thumb.png"),
                 disposition: 'inline',
                 x_sendfile: true
                )
    end

  end

  def destroy
    task = Task.find(@attachment.task_id)
    @attachment.destroy
    redirect_to(task)
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

end
