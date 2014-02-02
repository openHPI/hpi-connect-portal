class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role
      can :manage, :all if user.admin?

      can [:archive, :read], JobOffer

      can [:edit, :update], User, id: user.id

      initialize_student if user.student?
      initialize_staff user if user.staff?
    end
  end

  def initialize_student()
    can :create, Application
    can :read, Faq
    can :matching, JobOffer
    can :read, User, role: { name: 'Staff' }
  end

  def initialize_staff(user)
    user_id = user.id
    employer_id = user.employer_id

    can [:edit, :update], Employer, id: user.employer_id
    can :read, Application
    can :read, User, role: { name: 'Student' }
    can :read, User, role: { name: 'Staff' }
    can :manage, Faq

    can [:create, :complete, :reopen], JobOffer
    can [:accept, :decline], JobOffer, employer: { id: employer_id, deputy_id: user_id }
    can [:update, :destroy, :prolong], JobOffer, responsible_user_id: user_id
    can [:update, :destroy, :prolong, :accept], JobOffer, employer: { deputy_id: user_id }
    can [:update, :edit], JobOffer do |job|
      job.editable?
    end
    cannot :destroy, JobOffer do |job|
      job.running?
    end

    can [:accept, :decline], Application, job_offer: { responsible_user_id: user_id }
    
    can :destroy, User, role: { name: 'Staff' }, employer: { id: employer_id, deputy_id: user_id }
    can :promote, User, role: { name: 'Student'} if user.employer && user == user.employer.deputy
    can :promote, User, role: { name: 'Staff'} if user.employer && user == user.employer.deputy
  end
end
