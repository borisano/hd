class Task < ApplicationRecord
  belongs_to :request_type
  belongs_to :vertical
  belongs_to :priority
  belongs_to :status

  # https://www.spacevatican.org/2008/5/6/creating-multiple-associations-with-the-same-table/
  # http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records/10257516#10257516
  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id'
  belongs_to :reported_by, class_name: 'User', foreign_key: 'reported_by_id'

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments
  validates_length_of :attachments, maximum: 25

  #https://apidock.com/rails/ActiveModel/Validations/ClassMethods/validates
  validates :description, presence: true


  def send_slack
    # https://github.com/slack-ruby/slack-ruby-client
    client = Slack::Web::Client.new
    client.auth_test
    message = "*VERTICAL*: " + self.vertical.name + "\n"
    message += "*ID*: " + self.id.to_s + "\n"
    message += "*DESCRIPTION*: " + self.description + "\n"
    message += "*REQUEST-TYPE*: " + self.request_type.name + "\n"
    message += "*MEMBER-FACING*: " + self.member_facing.to_s + "\n"
    message += "*LINK*: " + self.link + "\n"
    message += "*PRIORITY*: " + self.priority.name + "\n"
    message += "*TITLE*: " + self.title + "\n"
    message += "*REQUESTED-BY*: " + User.find(self.reported_by).first_name + "\n"
    message += "*Timestamp*: " + self.created_at.strftime("%I:%M %p") + "\n"
    message += "*REPORTED DATE*: " + self.created_at.strftime("%d/%b/%y") + "\n"
    message += "*REQUIRED BY*: " + self.required_by.strftime("%d/%b/%y") + "\n"
    client.chat_postMessage(channel: '#bugs', text: message, as_user: true)
  end


end
