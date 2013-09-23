#!/usr/bin/env bash

apt-get -y update
apt-get -y install curl

# postgres
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
apt-get -y install postgresql
apt-get -y install libpq-dev

# init db
sudo -u postgres createuser --superuser ror_su
sudo -u postgres psql -c "ALTER USER ror_su WITH PASSWORD 'us_ror'"

# ruby
curl -L https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.0.0
rvm --default use 2.0.0

# gems
gem install rails -v 4.0.0
gem install pg

# init app
cp /vagrant/config/database.yml.default /vagrant/config/database.yml
(cd /vagrant && bundle install)