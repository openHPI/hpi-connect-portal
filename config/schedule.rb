# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/cron.log"

if environment == 'production'
  every :day, at: '1am' do
    runner "JobOffer.check_for_expired"
    runner "Alumni.export_adress_mapping"
  end

  every :thursday, at: '9am' do
    runner "Student.deliver_newsletters"
  end
end

# Learn more: http://github.com/javan/whenever
