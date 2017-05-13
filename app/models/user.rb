class User < ApplicationRecord
  after_destroy :remove_attachment_directory
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader, dependent: :destroy
  belongs_to :role

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  # https://www.spacevatican.org/2008/5/6/creating-multiple-associations-with-the-same-table/
  # http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records/10257516#10257516
  has_many :assignments, class_name: 'Task', foreign_key: 'assigned_to_id', dependent: :restrict_with_error
  has_many :reports,     class_name: 'Task', foreign_key: 'reported_by_id', dependent: :restrict_with_error

  def active_for_authentication?
      super && approved?
    end

    def inactive_message
      if !approved?
        :not_approved
      else
        super # Use whatever other message
      end
    end

    protected

    def remove_attachment_directory
      FileUtils.remove_dir(File.join(Rails.root,"dynamic_files",Rails.env, "user", "avatar", id.to_s), force: true)
    end

end
