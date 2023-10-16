docker-compose-file=~/data/repo/shell/docker/docker-compose.yml
database=alchemy
database-uri=postgres://postgres:postgres@localhost:5432/$(database)

up:
# docker-compose up
	docker-compose -f $(docker-compose-file) up -d postgres

psql:
# connect database
	docker-compose -f $(docker-compose-file) exec postgres \
	psql -p 5432 -U postgres -d $(database)

create:
# create database
#	docker-compose -f $(docker-compose-file) exec postgres \
#	psql -p 5432 -U postgres \
#	-c "CREATE DATABASE alchemy;"
	mix ecto.create

migrate:
# migrate Ecto
	mix ecto.migrate
