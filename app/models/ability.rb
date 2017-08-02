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

    can :create, [Question, Answer, Comment, Attachment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user

    can :mark_best, [Answer] do |answer|
      answer.question.user_id == user.id
    end

    can :destroy, [Attachment] do |attachment|
      attachment.attachable.user_id == user.id
    end

    can [:set_like, :set_dislike, :cancel_vote], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end
  end
end
