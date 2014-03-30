class Ability
  include CanCan::Ability

  def initialize(user)

    can :create, Student

    unless user.nil?
      can [:archive, :read], JobOffer
      can [:edit, :update, :read, :update_password], User, id: user.id
      can :read, Staff
      initialize_admin and return if user.admin?
      initialize_student user and return if user.student?
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

  def initialize_student(user)
    can :read, Faq
    can [:edit, :update, :show, :activate, :request_linkedin_import, :insert_imported_data], Student, id: user.manifestation.id
    cannot :show, JobOffer, status: JobStatus.completed

    if user.activated
      can :create, Application
      can :show, Student, activated: true
      can :matching, JobOffer
    end
  end

  def initialize_staff(user)
    staff = user.manifestation
    employer_id = staff.employer_id
    staff_id = staff.id

    can [:edit, :update, :read], Staff, id: staff.id

    can [:edit, :update], Employer, deputy_id: staff_id
    can [:edit, :update], Employer, id: employer_id

    if staff.employer.activated
      can :read, Application
      can :manage, Faq
      can :show, Student, activated: true
      cannot [:edit, :update], Student

      can [:create, :show], JobOffer
      can :complete, JobOffer, employer: staff.employer
      can :reopen, JobOffer, employer: staff.employer, status: JobStatus.completed
      can :reopen, JobOffer, employer: staff.employer, status: JobStatus.running
      can [:accept, :decline], JobOffer, employer: { deputy_id: staff_id }
      can :prolong, JobOffer, responsible_user_id: staff_id, status: JobStatus.running
      can :prolong, JobOffer, employer: { deputy_id: staff_id }, status: JobStatus.running
      can [:update, :destroy, :fire], JobOffer, responsible_user_id: staff_id
      can [:update, :destroy, :fire], JobOffer, employer: { deputy_id: staff_id }
      can [:update, :edit], JobOffer do |job|
        job.editable? && (job.responsible_user_id == staff_id || job.employer.deputy_id == staff_id)
      end
      cannot :destroy, JobOffer do |job|
        job.running?
      end

      can [:accept, :decline], Application, job_offer: { responsible_user_id: staff_id }

      can :destroy, Staff, manifestation: { employer: { id: employer_id, deputy_id: staff_id }}
    end
  end
end
