drop table if exists tasks;
create table tasks (
  id          integer primary key auto_increment,
  target_date date,
  sort_order  integer,
  body        text,
  delete_flg  bit default 0,
  created_at  datetime,
  updated_at  timestamp
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
