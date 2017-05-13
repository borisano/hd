# Note

This app is not ready for peer review. Unfortunetly this is the most
presentable code I have.

There are a lot of little things that need to be changed everywhere. This is
built with postgres in mind. If you change the db you will need to adjust the
search in the task controller. The task search uses "ILIKE" that's case
insensitive for postgres and is not supported by other db's. CSS is still a bit
wonky in some spots. The CSS files are a mess.

I have briefly started on the rspec tests. They are wired to operate with devise
and cancancan gems and that's about it.  

There are three notable things in this application.
1. The images and attachments are securely served through a controller. These
   files are not in the public folder but are in their own dynamic folder
2. When a task is made the task model will try to send a slack message.
3. The task model does not use a many_to_many with it's users relationships.
   There are two users attached to each task through the model.

# Installation

I run this in development and in production on
Ubuntu 16.04 LTS
NGINX
Puma (using puma manager)
Postgres 9.5
This is a rails 5.0.2 app
I use rbenv to handle ruby

carrierwave dependencies
sudo apt-get install imagemagick libmagickwand-dev

Postgres
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common postgresql-9.5 libpq-dev -y
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql

sudo -u postgres createuser deploy -s
sudo -u postgres psql
postgres=# \password deploy


rbenv variables

cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git
cd ~/bdhd

When booting up the application for the first time
rake db:create db:migrate db:seed

# TODO
* remove extra views ( Comments )
* remove un-used Json
* translations in views
* links not visited need styling
* tests
* attachment delete
* avatar delete
* thumbnails for pdf's and other doc types
* generic thumbnail
* better display for attachments
* translation missing: en.user.not-successfully-destroyed translation missing: en.sys_admin
* translation missing: en.user.successfully-created
* model restrictions needed for everything connected to tasks
  - users
  - verticals
  - statuses
  - request types
  - priorities
* model restrictions needed for roles connected to users
* foreign keys everywhere
* Look over user model, extra junk in there
* Look over task model, extra junk in there
* lock out devise
