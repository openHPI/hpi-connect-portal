# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every :day, at: '1am' do
  runner "JobOffer.check_for_expired"
  runner "Employer.check_for_expired"
end

# Learn more: http://github.com/javan/whenever
