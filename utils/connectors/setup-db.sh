 select password('confluent');

CREATE USER 'tolkien'@'%' IDENTIFIED BY PASSWORD  '*2A804FFB05640F8F90FB8E993175D8461F2AA859';
 GRANT ALL PRIVILEGES ON triggers.* TO 'tolkien'@'%';
 FLUSH PRIVILEGES;
