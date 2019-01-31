# frozen_string_literal: true

#rake tasks leveraged by whenever/crontab
namespace :dashboard do
  desc 'Send dlp data to geckoboard'
  task dlp: :environment do
    Dashboard.dlp
  end
end