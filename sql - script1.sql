CREATE TABLE client_contact
(
client_id serial NOT NULL,
first_name varchar(50) NOT NULL,
last_name varchar(50) NOT NULL,
phone_number varchar(15) NOT NULL,
email varchar(320) NOT NULL,
organisation_id bigint NOT NULL,
PRIMARY KEY (client_id)
) WITHOUT OIDS;
CREATE TABLE contract
(
contract_id serial NOT NULL,
description varchar(50) NOT NULL,
equipment_id bigint NOT NULL,
client_id bigint NOT NULL,
PRIMARY KEY (contract_id)
) WITHOUT OIDS;
CREATE TABLE employee
(
employee_id serial NOT NULL,
first_name varchar(50) NOT NULL,
last_name varchar(50) NOT NULL,
phone_number varchar(15) NOT NULL,
email varchar(320) NOT NULL,
login varchar(50) NOT NULL,
job_title_id bigint NOT NULL,
PRIMARY KEY (employee_id)
) WITHOUT OIDS;
CREATE TABLE job_title
(
job_title_id serial NOT NULL,
name varchar(50) NOT NULL,
PRIMARY KEY (job_title_id)
) WITHOUT OIDS;
CREATE TABLE equipment
(
equipment_id serial NOT NULL,
name varchar(50) NOT NULL,
serial_number varchar(50) NOT NULL,
PRIMARY KEY (equipment_id)
) WITHOUT OIDS;
CREATE TABLE client_organisation
(
client_organisation_id serial NOT NULL,
name varchar(50) NOT NULL,
email varchar(320) NOT NULL,
post_index varchar NOT NULL,
PRIMARY KEY (client_organisation_id)
) WITHOUT OIDS;
CREATE TABLE task
(
task_id bigserial NOT NULL,
description text NOT NULL,
status boolean NOT NULL,
creation_date timestamp with time zone NOT NULL,
completion_date timestamp with time zone,
deadline_date timestamp with time zone,
task_type_id bigint NOT NULL,
task_priority_id bigint NOT NULL,
creator_id bigint NOT NULL,
executor_id bigint,
contract_id bigint NOT NULL,
PRIMARY KEY (task_id)
) WITHOUT OIDS;
CREATE TABLE task_priority
(
task_priority_id serial NOT NULL,
name varchar(9) NOT NULL,
PRIMARY KEY (task_priority_id)
) WITHOUT OIDS;
CREATE TABLE task_type
(
task_type_id serial NOT NULL,
name varchar(50) NOT NULL,
PRIMARY KEY (task_type_id)
) WITHOUT OIDS;
ALTER TABLE task
ADD FOREIGN KEY (contract_id)
REFERENCES contract (contract_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE task
ADD FOREIGN KEY (creator_id)
REFERENCES employee (employee_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE task
ADD FOREIGN KEY (executor_id)
REFERENCES employee (employee_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE employee
ADD FOREIGN KEY (job_title_id)
REFERENCES job_title (job_title_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE contract
ADD FOREIGN KEY (equipment_id)
REFERENCES equipment (equipment_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE client_contact
ADD FOREIGN KEY (organisation_id)
REFERENCES client_organisation (client_organisation_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE contract
ADD FOREIGN KEY (client_id)
REFERENCES client_organisation (client_organisation_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE task
ADD FOREIGN KEY (task_priority_id)
REFERENCES task_priority (task_priority_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;
ALTER TABLE task
ADD FOREIGN KEY (task_type_id)
REFERENCES task_type (task_type_id)
ON UPDATE RESTRICT
ON DELETE RESTRICT
;

alter table task enable row level security;

create role Administrator;
create role Manager;
create role Worker;
create user alexpushka in role Manager;
create user margaritka in role Manager;
create user kizaru in role Worker;
grant usage, select on all sequences in schema public to Administrator, Manager,
Worker;
grant select on employee, job_title to Manager, Worker;

grant all on all tables in schema public to Administrator;
create policy admin_access on task for all to Administrator using (true) with
check (true);

grant all on client_organisation, client_contact, contract, equipment to Manager,
Worker;

grant insert, select on task to Manager, Worker;
create policy task_insert on task for insert to Manager, Worker with check
(true);

grant update (description, completion_date, task_priority_id, task_type_id,
contract_id)
on task to Manager, Worker;
create policy author_change on task for update to Manager, Worker using (true)
with check (
task.status = true and (select login from employee where (employee_id =
task.creator_id)) = CURRENT_USER
);

grant update (executor_id) on task to Manager;
create policy change_executor on task for update to Manager using (true) with
check (
task.status = true and (select login from employee where (employee_id =
task.creator_id)) = CURRENT_USER
);

grant update (status, completion_date) on task to Manager, Worker;

create policy see_task on task for select to Manager, Worker using (
(select login from employee where (employee_id = task.executor_id)) =
CURRENT_USER
or (select login from employee where (employee_id = task.creator_id)) =
CURRENT_USER
);

create policy manager_see_task on task for select to Manager using (
(select name from job_title where (job_title_id = (select
job_title_id from employee where (employee_id = task.creator_id)))) = 'Рядовой
сотрудник'
);

create policy change_task_status on task for update to Manager, Worker using
(true) with check (
task.status = true and
(select login from employee where (employee_id = task.executor_id)) =
CURRENT_USER
or (select login from employee where (employee_id = task.creator_id)) =
CURRENT_USER
);


-- новое задание
create or replace procedure new_task (description text, deadline_date timestamptz,
task_priority_id int, task_type_id int, contract_id int) as $$
declare
creator_id int;
begin
select employee_id into creator_id from employee where (login =
CURRENT_USER);
execute format('insert into Task (description, status, creation_date,
deadline_date, completion_date, task_priority_id, task_type_id, contract_id,
author_id, executor_id)
values (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,%L)',
description, false, CURRENT_TIMESTAMP, deadline_date, null, task_priority_id,
task_type_id, contract_id, creator_id, null);
end;
$$ language plpgsql;
grant execute on PROCEDURE new_task() to manager, worker;
-- удаление через 12 месяцев
grant delete on task to Manager, Worker;
create or replace function delete_task() returns trigger as
$$
BEGIN
delete from Task where
status = true and age(current_timestamp, completion_date) > interval '12 months';
return new;
end;
$$ language plpgsql;
create trigger delete_task_trigger before insert or update on task
for each statement
execute function delete_task();
--установка даты завершения при изменении статуса
create or replace function set_completion_date() returns trigger as $$
begin
update task
set completion_date = CURRENT_TIMESTAMP
where status = true and completion_date is null;
return new;
end;
$$ language plpgsql;
create trigger completion_date_trigger after update on task
for each row
execute procedure set_completion_date();

-- индексы
create index executor_id_idx on task(executor_id);
create index author_id_idx on task(creator_id);
create index employee_id_idx on employee(employee_id);
create index contact_person_id_idx on client_contact(client_id);
create index contract_id_idx on contract(contract_id);
create index equipment_id_idx on equipment(equipment_id);

