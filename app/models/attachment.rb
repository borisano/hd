class Attachment < ApplicationRecord
  after_destroy :remove_attachment_directory

  mount_uploader :doc, DocUploader, dependent: :destroy
  belongs_to :task
  validates_associated :task

  def is_image?
    [".png", ".JPEG",".JPG",".jpeg",".jpg"].include? File.extname(self.doc_identifier)
  end

  protected

   def remove_attachment_directory
     FileUtils.remove_dir(File.join(Rails.root,"dynamic_files",Rails.env, "attachment", "doc", id.to_s), force: true)
   end

end
