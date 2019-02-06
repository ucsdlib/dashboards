# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']
set :output, "/Users/huawei/git/dashboards/tmp/cron_log.log"
set :environment, 'development' 

every 1.minutes do
  rake "dashboard:dlp"
end

# Learn more: http://github.com/javan/whenever
