class ApplicationsMailer < ActionMailer::Base
  default from: "hpi-hiwi-portal@hpi.uni-potsdam.de"

  def application_accepted_student_email(application)
  	@application = application  	
    mail(to: @application.user.email, subject: (t "applications_mailer.students.accepted.subject", job_title: @application.job_offer.title, chair: @application.job_offer.chair.name))
  end

  def application_declined_student_email(application)
    @application = application    
    mail(to: @application.user.email, subject: (t "applications_mailer.students.declined.subject", job_title: @application.job_offer.title, chair: @application.job_offer.chair.name))
  end
end
