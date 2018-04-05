class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Student

    unless user.nil?
      can [:archive, :read], JobOffer
      can [:edit, :update, :read, :update_password], User, id: user.id
      can :show, Staff
      initialize_admin and return if user.admin?
      initialize_student user and return if user.student?
      initialize_staff user and return if user.staff?
    end
  end

  def initialize_admin
    can :manage, :all
    cannot :reopen, JobOffer, status: JobStatus.pending
  end

  def initialize_student(user)
    can :read, Faq

    can [:read, :update, :activate, :insert_imported_data, :destroy], Student, id: user.manifestation.id

    can [:read, :destroy], NewsletterOrder, student: user.manifestation
    can :create, NewsletterOrder

    cannot :show, JobOffer, status: JobStatus.closed
    cannot :show, Employer

    if user.activated
      can :read, Student do |student|
        student.activated && (student.visibility_id == Student::VISIBILITYS.index('employers_and_students') ||
                              student.visibility_id == Student::VISIBILITYS.index('students_only') ||
                              student.id == user.manifestation.id)
      end

      can :matching, JobOffer

      can [:create, :read], Rating
      can [:update, :destroy], Rating do |rating|
        user.manifestation.id == rating.student.id
      end

      can :read, Employer, activated: true
    end
  end

  def initialize_staff(user)
    staff = user.manifestation
    employer_id = staff.employer_id
    staff_id = staff.id

    can [:create, :show], JobOffer

    cannot :show, JobOffer, status: JobStatus.closed
    can :show, JobOffer, status: JobStatus.closed, employer: staff.employer

    can [:edit, :update, :show], Staff, id: staff.id

    can [:read, :edit, :update, :invite_colleague], Employer, id: employer_id
    can :home, Employer

    if staff.employer.activated
      can :manage, Faq

      can :read, Employer, activated: true

      cannot [:edit, :update], Student
      can :close, JobOffer, employer: staff.employer
      can :reopen, JobOffer, employer: staff.employer, status: JobStatus.active
      can :reopen, JobOffer, employer: staff.employer, status: JobStatus.closed
      can :request_prolong, JobOffer, employer: { id: employer_id }, status: JobStatus.active
      can [:update, :destroy], JobOffer, employer: staff.employer
      can [:update, :destroy], JobOffer, employer: { id: employer_id }
      can [:update, :edit], JobOffer do |job|
        job.editable? && job.employer.id == employer_id
      end
      cannot :destroy, JobOffer do |job|
        job.active?
      end

      can :destroy, Staff, employer: staff.employer

      if staff.employer.premium?
        can :read, Student do |student|
          student.activated && student.visibility_id > 0
        end
      end
    end
  end
end
