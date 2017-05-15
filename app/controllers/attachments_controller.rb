class AttachmentsController < ApplicationController
  load_and_authorize_resource

  def serve_doc
    public_images_path = File.join(Rails.root,"public","site_images")
    image_path = File.join(public_images_path,"no_doc_thumb.png")
    base_path = File.join( Rails.root,
                            "dynamic_files",
                            Rails.env,
                            "attachment",
                            "doc",
                            @attachment.id.to_s
                          )

    unless @attachment.doc_identifier.blank?

      if params[:type] == "thumb"
        if @attachment.is_image?
          image_path = File.join(base_path,"#{params[:type]}_#{@attachment.doc_identifier}")
        else # thumbnail for other file types. Eaxmple: .txt, .doc, .pdf, etc ...
          image_path = File.join(public_images_path,"doc_thumb.png")
        end
      else # If it's not a thumb the user is requesting the full attachment
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
    @attachment.destroy
    redirect_to(request.env['HTTP_REFERER']) # TODO Fix this
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

end
