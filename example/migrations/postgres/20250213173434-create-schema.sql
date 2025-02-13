-- +migrate Up
create table users(id serial primary key, name varchar(255));

-- +migrate Down
drop table users;