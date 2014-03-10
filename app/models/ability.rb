class Ability
  include CanCan::Ability

  def initialize(user)

    can :create, Student
    can :create, Employer

    unless user.nil?
      can [:archive, :read], JobOffer
      can [:edit, :update, :read], User, id: user.id
      can :read, Staff
      initialize_admin and return if user.admin?
      initialize_student and return if user.student?
      initialize_staff user and return if user.staff?
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
    cannot :show, JobOffer, status: JobStatus.completed
    can :matching, JobOffer
  end

  def initialize_staff(user)
    user_id = user.id
    staff = user.manifestation
    employer_id = staff.employer_id

    can [:edit, :update], Employer, deputy_id: user_id
    can [:edit, :update], Employer, id: employer_id
    can :read, Application
    can :read, Students
    can :manage, Faq

    can :create, JobOffer
    cannot :show, JobOffer, status: JobStatus.completed
    can :complete, JobOffer, employer: staff.employer
    can :reopen, JobOffer, employer: staff.employer, status: JobStatus.completed
    can :reopen, JobOffer, employer: staff.employer, status: JobStatus.running
    can [:accept, :decline], JobOffer, employer: { deputy_id: user_id }
    can :prolong, JobOffer, responsible_user_id: user_id, status: JobStatus.running
    can :prolong, JobOffer, employer: { deputy_id: user_id }, status: JobStatus.running
    can [:update, :destroy, :fire], JobOffer, responsible_user_id: user_id
    can [:update, :destroy, :fire], JobOffer, employer: { deputy_id: user_id }
    can [:update, :edit], JobOffer do |job|
      job.editable? && (job.responsible_user_id == user_id || job.employer.deputy_id == user_id)
    end
    cannot :destroy, JobOffer do |job|
      job.running?
    end

    can [:accept, :decline], Application, job_offer: { responsible_user_id: user_id }

    can :destroy, Staff, manifestation: { employer: { id: employer_id, deputy_id: user_id }}
  end
end
