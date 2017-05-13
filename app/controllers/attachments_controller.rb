class AttachmentsController < ApplicationController
  load_and_authorize_resource
  def serve_doc
    unless @attachment.doc_identifier.blank?
      if params[:type]
        if params[:type] == "thumb"
          if @attachment.is_image?
            image_name = "#{params[:type]}_#{@attachment.doc_identifier}"
            image_path = File.join(Rails.root,"dynamic_files",Rails.env, "attachment", "doc", @attachment.id.to_s,image_name)
          else
            image_path = File.join(Rails.root,"public","site_images","no_doc_image_thumb.png") #TODO Fix DRY
          end
        else
          image_name = @attachment.doc_identifier
          image_path = File.join(Rails.root,"dynamic_files",Rails.env, "attachment", "doc", @attachment.id.to_s,image_name)
        end
      end
    else
      image_path = File.join(Rails.root,"public","site_images","no_doc_image_thumb.png") #TODO Fix DRY
    end

    unless send_file( image_path,disposition: 'inline', x_sendfile: true )
      return "some default image" #TODO add default thumb
    end
  end

  def destroy
    @attachment.destroy
    redirect_to(request.env['HTTP_REFERER'])
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

end
