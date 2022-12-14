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