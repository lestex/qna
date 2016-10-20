class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :set_email, User
  end

  def admin_abilities
    can :manage, :all
  end


  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user: user
    can :destroy, Attachment do |attachment|
      user.owner_of?(attachment.attachable)
    end
    can :mark_best, Answer do |subject|
      user.owner_of?(subject.question)
    end
    can [:vote_up, :vote_down], [Question, Answer] do |subject|
      !user.owner_of?(subject)
    end
    can [:vote_cancel], [Question, Answer] do |subject|
      user.owner_of?(subject)
    end
  end
end
