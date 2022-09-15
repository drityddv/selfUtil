# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.24-log)
# Database: pratice
# Generation Time: 2022-06-05 18:34:59 +0000
# ************************************************************


# Dump of table emp
# ------------------------------------------------------------

DROP TABLE IF EXISTS `emp`;

CREATE TABLE `emp` (
  `emp_no` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `e_name` varchar(120) NOT NULL DEFAULT '',
  `job` varchar(120) NOT NULL DEFAULT '',
  `mgr` smallint(5) unsigned NOT NULL DEFAULT '0',
  `hire_data` date NOT NULL,
  `sal` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `comm` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `dept_no` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`emp_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `emp` WRITE;
/*!40000 ALTER TABLE `emp` DISABLE KEYS */;

-- INSERT INTO `emp` (`emp_no`, `e_name`, `job`, `mgr`, `hire_data`, `sal`, `comm`, `dept_no`)
-- VALUES
-- 	(1,'JACK','SERVER',0,'2022-06-06',7000.50,1500.00,1);

/*!40000 ALTER TABLE `emp` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
