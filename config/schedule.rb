set :output, 'log/crontab.log'
ENV['RAILS_ENV'] ||= 'development'
set :environment, ENV['RAILS_ENV']

# 1分毎に回す
every 1.minute do
  rake 'auto_exhibit:auto_exhibit'
end