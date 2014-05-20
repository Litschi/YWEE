-- MySQL Script generated by MySQL Workbench
-- Mo 19 Mai 2014 23:00:50 CEST
-- Model: New Model    Version: 1.0
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema pts
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pts` ;
CREATE SCHEMA IF NOT EXISTS `pts` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `pts` ;

-- -----------------------------------------------------
-- Table `pts`.`gaestebuch`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`gaestebuch` ;

CREATE TABLE IF NOT EXISTS `pts`.`gaestebuch` (
  `eintrag` TEXT NOT NULL,
  `benutzername` VARCHAR(45) NOT NULL,
  `autorisiert` INT UNSIGNED NOT NULL,
  INDEX `aut` USING BTREE (`autorisiert` ASC)  COMMENT 'Zum schnellen Filtern von unautorisierten Nachrichten')
ENGINE = InnoDB
COMMENT = 'Enthält alle Autorisierten und Unautorisierten Gästebucheinträge';


-- -----------------------------------------------------
-- Table `pts`.`mitglieder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`mitglieder` ;

CREATE TABLE IF NOT EXISTS `pts`.`mitglieder` (
  `benutzername` VARCHAR(20) NOT NULL,
  `geschlecht` INT NOT NULL,
  `vorname` VARCHAR(45) NOT NULL,
  `nachname` VARCHAR(45) NOT NULL,
  `geburtsdatum` DATE NOT NULL,
  `plz` VARCHAR(5) NOT NULL,
  `wohnort` VARCHAR(45) NOT NULL,
  `strasse` VARCHAR(45) NOT NULL,
  `hausnummer` INT UNSIGNED NOT NULL,
  `hnrzusatz` VARCHAR(20) NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `sprache` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`benutzername`),
  INDEX `Wohnort` (`wohnort` ASC))
ENGINE = InnoDB
COMMENT = 'Enthält alle persönlichen Daten eines jeden Mitglieds';


-- -----------------------------------------------------
-- Table `pts`.`login`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`login` ;

CREATE TABLE IF NOT EXISTS `pts`.`login` (
  `benutzername` VARCHAR(20) NOT NULL,
  `passwort` VARCHAR(32) NOT NULL,
  `rolle` INT NOT NULL COMMENT '1: Admin;' /* comment truncated */ /*2: Nutzer*/,
  PRIMARY KEY (`benutzername`),
  INDEX `Rolle` (`rolle` ASC),
  CONSTRAINT `fk_login_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält die Benutzernamen und Passwörter (in MD5)';


-- -----------------------------------------------------
-- Table `pts`.`profilbild`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`profilbild` ;

CREATE TABLE IF NOT EXISTS `pts`.`profilbild` (
  `benutzername` VARCHAR(20) NOT NULL,
  `bild` BLOB NULL,
  PRIMARY KEY (`benutzername`),
  CONSTRAINT `fk_profilbild_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Speichert die Profilbilder';


-- -----------------------------------------------------
-- Table `pts`.`nachrichten`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`nachrichten` ;

CREATE TABLE IF NOT EXISTS `pts`.`nachrichten` (
  `benutzername` VARCHAR(20) NOT NULL COMMENT '\"an\"',
  `von` VARCHAR(20) NOT NULL,
  `zeit` DATETIME NOT NULL,
  `nachricht` TEXT NOT NULL,
  `status` INT NOT NULL COMMENT '0: gelesen;' /* comment truncated */ /*1: ungelesen;*/,
  PRIMARY KEY (`benutzername`, `von`, `zeit`),
  CONSTRAINT `fk_nachrichten_mitglieder`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält alle Nachrichten aller Nutzer.';


-- -----------------------------------------------------
-- Table `pts`.`besucherzaehler`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`besucherzaehler` ;

CREATE TABLE IF NOT EXISTS `pts`.`besucherzaehler` (
  `zaehler` INT UNSIGNED NOT NULL)
ENGINE = InnoDB
COMMENT = 'Besucherzähler';


-- -----------------------------------------------------
-- Table `pts`.`tutoren`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`tutoren` ;

CREATE TABLE IF NOT EXISTS `pts`.`tutoren` (
  `benutzername` VARCHAR(20) NOT NULL,
  `umkreis` INT UNSIGNED NOT NULL,
  `stundenlohn` INT UNSIGNED NOT NULL,
  `bewertung` FLOAT UNSIGNED NOT NULL,
  `gewichtung` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`benutzername`),
  CONSTRAINT `fk_tutoren_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tutoren samt Informationen.';


-- -----------------------------------------------------
-- Table `pts`.`verfuegbarkeit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`verfuegbarkeit` ;

CREATE TABLE IF NOT EXISTS `pts`.`verfuegbarkeit` (
  `benutzername` VARCHAR(20) NOT NULL,
  `zeitraum` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`benutzername`, `zeitraum`),
  CONSTRAINT `fk_verfuegbarkeit_tutoren1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`tutoren` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält die Verfügbarkeiten der einzelnen Tutoren.';


-- -----------------------------------------------------
-- Table `pts`.`leistung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`leistung` ;

CREATE TABLE IF NOT EXISTS `pts`.`leistung` (
  `benutzername` VARCHAR(20) NOT NULL,
  `fach` VARCHAR(30) NOT NULL,
  `stufen` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`benutzername`, `fach`, `stufen`),
  CONSTRAINT `fk_leistung_tutoren1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`tutoren` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält die Leistungen eines Tutors.';


-- -----------------------------------------------------
-- Table `pts`.`schwarzesbrett`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`schwarzesbrett` ;

CREATE TABLE IF NOT EXISTS `pts`.`schwarzesbrett` (
  `benutzername` VARCHAR(45) NOT NULL,
  `zeit` DATETIME NOT NULL,
  `nachricht` TEXT NOT NULL,
  PRIMARY KEY (`benutzername`, `zeit`),
  CONSTRAINT `fk_schwarzesbrett_tutoren1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`tutoren` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Schwarzes Brett der Tutoren.';


-- -----------------------------------------------------
-- Table `pts`.`news`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`news` ;

CREATE TABLE IF NOT EXISTS `pts`.`news` (
  `benutzername` VARCHAR(20) NOT NULL,
  `zeit` DATETIME NOT NULL,
  `nachricht` TEXT NOT NULL,
  PRIMARY KEY (`benutzername`, `zeit`))
ENGINE = InnoDB
COMMENT = 'Newsticker';


-- -----------------------------------------------------
-- Table `pts`.`mentee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`mentee` ;

CREATE TABLE IF NOT EXISTS `pts`.`mentee` (
  `benutzername` VARCHAR(20) NOT NULL,
  `tutor` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`benutzername`, `tutor`),
  CONSTRAINT `fk_mentee_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `pts`.`mitglieder` (`benutzername`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält alle Lernbeziehungen';


-- -----------------------------------------------------
-- Table `pts`.`abrechnungen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pts`.`abrechnungen` ;

CREATE TABLE IF NOT EXISTS `pts`.`abrechnungen` (
  `benutzername` VARCHAR(20) NOT NULL,
  `zeit` DATETIME NOT NULL,
  `vorname` VARCHAR(45) NOT NULL,
  `nachname` VARCHAR(45) NOT NULL,
  `kreditkartennummer` VARCHAR(45) NOT NULL,
  `ablaufdatum` DATE NOT NULL,
  `pruefziffer` VARCHAR(4) NOT NULL,
  `empfvorname` VARCHAR(45) NOT NULL,
  `empfnachname` VARCHAR(45) NOT NULL,
  `empfkto` VARCHAR(45) NOT NULL,
  `empfblz` VARCHAR(45) NOT NULL,
  `verwendungszeck` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`benutzername`, `zeit`))
ENGINE = InnoDB
COMMENT = 'Enthält alle auszuführenden Zahlungen.';

USE `pts` ;

-- -----------------------------------------------------
-- View `pts`.`suche`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `pts`.`suche` ;
DROP TABLE IF EXISTS `pts`.`suche`;
USE `pts`;
CREATE  OR REPLACE VIEW `suche` AS 
	(select  m.benutzername, m.Wohnort, t.umkreis, t.stundenlohn, t.bewertung, l.fach, l.stufen 
		from tutoren t join leistung l join mitglieder m 
			on m.benutzername = t.benutzername and m.benutzername = l.benutzername);

GRANT ALL ON `pts`.* TO 'ptsadmin'@'localhost';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `pts`.`mitglieder`
-- -----------------------------------------------------
START TRANSACTION;
USE `pts`;
INSERT INTO `pts`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('admin', 1, 'Daniel', 'Irgendeiner', '2000-01-01', '12345', 'Irgendwo', 'Irgendeine', 1, '0', 'admin@spam.de', '123456', 'deutsch');

COMMIT;


-- -----------------------------------------------------
-- Data for table `pts`.`login`
-- -----------------------------------------------------
START TRANSACTION;
USE `pts`;
INSERT INTO `pts`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('admin', 'e8636ea013e682faf61f56ce1cb1ab5c', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `pts`.`besucherzaehler`
-- -----------------------------------------------------
START TRANSACTION;
USE `pts`;
INSERT INTO `pts`.`besucherzaehler` (`zaehler`) VALUES (0);

COMMIT;

