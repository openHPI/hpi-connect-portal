class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role
      can [:archive, :read], JobOffer

      can [:edit, :update, :read], User, id: user.id
      can :read, User, role: { name: 'Staff' }
      initialize_student if user.student?
      initialize_staff user if user.staff?
      initialize_admin if user.admin?
    end
  end

  def initialize_admin
    can :manage, :all
    cannot :prolong, JobOffer, status: JobStatus.open
    cannot :prolong, JobOffer, status: JobStatus.pending
    cannot :prolong, JobOffer, status: JobStatus.completed
    cannot :reopen, JobOffer, status: JobStatus.open
    cannot :reopen, JobOffer, status: JobStatus.pending
  end

  def initialize_student
    can :create, Application
    can :read, Faq
    cannot :index, User
    can :matching, JobOffer
  end

  def initialize_staff(user)
    user_id = user.id
    employer_id = user.employer_id

    can [:edit, :update], Employer, deputy_id: user_id
    can [:edit, :update], Employer, id: employer_id
    can :read, Application
    can :read, User, role: { name: 'Student' }
    can :manage, Faq

    can :create, JobOffer
    can :complete, JobOffer, employer: user.employer
    can :reopen, JobOffer, employer: user.employer, status: JobStatus.completed
    can :reopen, JobOffer, employer: user.employer, status: JobStatus.running
    can [:accept, :decline], JobOffer, employer: { deputy_id: user_id }
    can :prolong, JobOffer, responsible_user_id: user_id, status: JobStatus.running
    can :prolong, JobOffer, employer: { deputy_id: user_id }, status: JobStatus.running
    can [:update, :destroy], JobOffer, responsible_user_id: user_id
    can [:update, :destroy], JobOffer, employer: { deputy_id: user_id }
    can [:update, :edit], JobOffer do |job|
      job.editable? && (job.responsible_user_id == user_id || job.employer.deputy_id == user_id)
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
