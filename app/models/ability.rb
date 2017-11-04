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

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Attachment, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id

    can :mark_best, [Answer] do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, [Attachment] do |attachment|
      user.author_of?(attachment.attachable)
    end

    can [:set_like, :set_dislike, :cancel_vote], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    can [:me, :index], User, id: user.id
  end
end
