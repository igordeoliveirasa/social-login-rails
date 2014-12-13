psql -U postgres -c "drop database db_environment"
psql -U postgres -c "create database db_environment"
rake db:migrate
