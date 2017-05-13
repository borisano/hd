class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role.name == 'admin'
      can :manage, :all
    elsif user.role.name == 'business'
      can :read, User
      can :read, Status
      can :read, Priority
      can :read, Vertical
      can :read, RequestType

      can :read,    Comment
      can :create,  Comment
      can :update,  Comment, :user_id => user.id
      can :destroy, Comment, :user_id => user.id

      can :read,    Task
      can :create,  Task
      can :update,  Task
      can :destroy, Task, :reported_by => user.id

      can :manage, Attachment
    end
  end
end
