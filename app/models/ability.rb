class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role
      can :manage, :all if user.admin?

      initialize_student user if user.student?
      initialize_staff user, user.employer_id if user.staff?
    end
  end

  def initialize_student(user)
    can :create, Application
    can :read, Faq
    can :read, User, role: { name: 'Staff' }
  end

  def initialize_staff(user, employer_id)
    user_id = user.id
    
    can :edit, Employer, id: user.employer_id
    can :read, Application
    can :read, User, role: { name: 'Student' }
    can :read, User, role: { name: 'Staff' }
    can :manage, Faq

    can [:create, :complete, :reopen], JobOffer, employer_id: employer_id

    can [:update, :destroy, :prolong], JobOffer, responsible_user_id: user_id
    can [:update, :destroy, :prolong], JobOffer, employer: { deputy_id: user_id }
    can [:accept, :decline], Application, responsible_user_id: user_id

    can [:accept, :decline], JobOffer, employer: { id: employer_id, deputy_id: user_id }
    can :destroy, User, role: { name: 'Staff' }, employer: { id: employer_id, deputy_id: user_id }
    can :promote, User, role: { name: 'Student' } if user.employer && user == user.employer.deputy
  end
end
