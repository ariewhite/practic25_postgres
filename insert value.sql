insert into task_priority(name)
values
('Низкий'), ('Средний'), ('Высокий');
insert into task_type(name)
values
('Звонок'), ('Визит'), ('Доставка'), ('Починка');
insert into job_title(name)
values
('Менеджер'), ('Рядовой сотрудник');
insert into employee(first_name, last_name, phone_number, email, login,
job_title_id)
values
('Александ', 'Пушкин', '8916123455', 'pushkin.a@gmail.com', 'alexpushka', 1),
('Михаил', 'Булгаков', '8925734548', 'bulgakmoscow@yandex.ru', 'margaritka',1),
('Олег', 'Нечипоренко', '8922822813', 'barcelona228@gmail.com', 'kizaru',2);
insert into equipment(name, serial_number)
values
('Часы', '12345'),
('Drugs', '67899'),
('Книга', '73245');
insert into client_organisation(name, email, post_index)
values
('Магнит', 'info@magnit.ru', 'г. Москва, Магнитовская 12'),
('Улица корпор', 'corp@street.ru', 'Везде'),
('Черняковская корпор', 'info@ufa.dark.ru', 'г. Уфа, Проспект Мира, 777');
insert into client_contact(first_name, last_name, phone_number, email,
organisation_id)
values
('Алишер', 'Моргенштерн', '89153462398', 'morgen@yandex.ru', 1),
('Ри́чард Пост', 'Остин', '89256643244', 'post@malone.com', 2),
('Лейтан Моисей', 'Стэнли Эколс', '89168899009', 'lil@mosey.ru', 3);
insert into contract(description, client_id, equipment_id)
values
('починка часов', 3, 2),
('доставка drugsов', 2, 1),
('написание книги', 1, 3);
insert into task(description, status, creation_date, completion_date,
deadline_date, task_type_id, task_priority_id, contract_id, creator_id, executor_id)
values
('созвониться насчёт доставки', false, '2022-10-3 10:06:40+05', null,
'2022-10-3 15:00:00+05', 1, 2, 2, 2, 3),
('ремонт часов', true, '2022-09-22 11:10:20+05', '2022-09-22
20:30:40+05', '2022-10-1 10:00:00+05', 4, 2, 1, 1, null),
('доставить drugsы', false, '2022-10-1 12:36:10+05', null, '2022-10-2 16:00:00+05', 3, 2, 2, 2, 3);


select * from employee
SELECT rolname FROM pg_roles
