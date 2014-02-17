Setup steps

1) bundle install

2) rake db:create

3) rake db:migrate

4) rake sunspot:solr:start

5) rake sunspot:reindex

6) rake db:seed

7) rake populate:activity_types

8) start redis server by executing "redis-server" on terminal.

9) start resque work by executing "rake resque:work" on terminal.

10) start app by executing "rails s" on terminal.

11) To update cronjob, execute following command on terminal.
    
For development
    
    `whenever --update-crontab --set environment=development`

For production
    
    `whenever --update-crontab --set environment=production`

12) For Active-Admin URL: 'http://localhost:3000/admin/login'
   Default Admin ID: 'admin@example.com' & Password: 'password'

13) To run specs u need to do following,
    -> rake db:test:prepare

    -> rake sunspot:solr:start

    -> start redis server by executing "redis-server" on terminal.

    -> rake populate:activity_types  RAILS_ENV=test

    -> run spec by executing "rspec" on terminal.

14) To run in production mode u need to do following,
    -> To precompile assets execute "RAILS_ENV=production rake assets:precompile" on terminal.

    -> start redis server by executing "redis-server" on terminal.

    -> To start solr execute "rake sunspot:solr:start RAILS_ENV = production".

    -> To start server execute "rails s -e production".

    -> To update cronjob "whenever --update-crontab".

    -> To start resque job "RAILS_ENV=production rake resque:work &"

