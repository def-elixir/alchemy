docker-compose-file=~/data/repo/sketch/docker-compose.yml
database=alchemy
database-uri=postgres://postgres:postgres@localhost:5432/$(database)

up:
# docker-compose up
	docker-compose -f $(docker-compose-file) up -d postgres

down:
# docker-compose down
	docker-compose -f $(docker-compose-file) down

psql:
# connect database
	docker-compose -f $(docker-compose-file) exec postgres \
	psql -p 5432 -U postgres -d $(database)

create:
# Ecto create database
	mix ecto.create

drop:
# Ecto drop database
	mix ecto.drop

migrate:
# Ecto migrate
	mix ecto.migrate

reset: drop create migrate
# Ecto remake database
