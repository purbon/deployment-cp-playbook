GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator' IDENTIFIED BY 'replpass';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium' IDENTIFIED BY 'dbz';

CREATE DATABASE demo;
GRANT ALL PRIVILEGES ON demo.* TO 'mysqluser'@'%';

use demo;

CREATE TABLE CUSTOMERS (
  id mediumint(8) unsigned NOT NULL auto_increment,
  firstName varchar(255) default NULL,
  lastName varchar(255) default NULL,
  gender varchar(255) default NULL,
  address varchar(255) default NULL,
  city varchar(255) default NULL,
  phone varchar(255) default NULL,
  email varchar(255) default NULL,
  status varchar(255) default NULL,
  createdDate varchar(255) default NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;