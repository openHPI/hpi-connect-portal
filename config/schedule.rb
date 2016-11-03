# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/cron.log"

every :day, at: '1am' do
  runner "JobOffer.check_for_expired"
end

every :thursday, at: '9am' do
  runner "Student.deliver_newsletters"
end

# Learn more: http://github.com/javan/whenever
