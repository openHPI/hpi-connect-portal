# postgres
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
apt-get -y install postgresql
apt-get -y install libpq-dev

# init db
sudo -u postgres createuser --superuser ror_su
sudo -u postgres psql -c "ALTER USER ror_su WITH PASSWORD 'us_ror'"

# copy the database.yml file
cp /vagrant/config/database.yml.default /vagrant/config/database.yml