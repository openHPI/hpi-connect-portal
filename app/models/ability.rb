class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.role

      if user.admin?
        can :manage, :all
      end

      if user.student?
        can :create, Application
        can :read, Faq
      end

      if user.staff?
        can :edit, Employer, id: user.employer_id
        can :read, Application
        can [:create, :complete, :reopen], JobOffer, employer_id: user.employer_id
        can [:update, :destroy, :prolong], JobOffer, responsible_user_id: user.id
        can :manage, Faq
      end

      if user.deputy?
        can :update, User
      end
    end
  end
end
