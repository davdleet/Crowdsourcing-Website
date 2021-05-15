-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema crowdsourcing
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema crowdsourcing
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `crowdsourcing` DEFAULT CHARACTER SET utf8 ;
USE `crowdsourcing` ;

-- -----------------------------------------------------
-- Table `crowdsourcing`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`account` (
  `AccID` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NULL DEFAULT NULL,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Gender` VARCHAR(1) NULL DEFAULT NULL,
  `Phone_Number` VARCHAR(11) NULL DEFAULT NULL,
  `Address` VARCHAR(45) NULL DEFAULT NULL,
  `DOB` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`AccID`),
  UNIQUE INDEX `AccType_UNIQUE` (`AccID` ASC) VISIBLE,
  INDEX `Eval_Foreign` (`AccID` ASC) INVISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`administrator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`administrator` (
  `AccID_Admin` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AccID_Admin`),
  INDEX `AccType_Admin_idx` (`AccID_Admin` ASC) VISIBLE,
  CONSTRAINT `Admin_Foreign`
    FOREIGN KEY (`AccID_Admin`)
    REFERENCES `crowdsourcing`.`account` (`AccID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`evaluator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`evaluator` (
  `AccID_Eval` VARCHAR(45) NOT NULL,
  `AccType` VARCHAR(15) NULL DEFAULT 'Evaluator',
  PRIMARY KEY (`AccID_Eval`),
  INDEX `AccType_Eval_idx` (`AccType` ASC, `AccID_Eval` ASC) VISIBLE,
  CONSTRAINT `Eval_Foreign`
    FOREIGN KEY (`AccID_Eval`)
    REFERENCES `crowdsourcing`.`account` (`AccID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`pdsequencefile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`pdsequencefile` (
  `PD_ID` INT NOT NULL,
  `SubmitterId` VARCHAR(45) NULL DEFAULT NULL,
  `TaskName` VARCHAR(45) NULL DEFAULT NULL,
  `Ogdata_Id` INT NULL DEFAULT NULL,
  `TotalTuple` INT NULL DEFAULT NULL,
  `DuplicatedTuple` INT NULL DEFAULT NULL,
  `NullRatio` JSON NULL DEFAULT NULL,
  `Evaluated` VARCHAR(1) NULL DEFAULT NULL,
  `PD_File` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`PD_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`task` (
  `TD_ID` INT NOT NULL AUTO_INCREMENT,
  `TName` VARCHAR(45) NOT NULL,
  `Explanation` TEXT NULL DEFAULT NULL,
  `Upload_Interval` INT NULL DEFAULT NULL,
  `TDT_SChema` JSON NOT NULL,
  `Guideline` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`TD_ID`),
  INDEX `index3` (`TName` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`taskdatatable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`taskdatatable` (
  `TD_ID` INT NOT NULL DEFAULT '1',
  `Submitter_ID` VARCHAR(45) NULL DEFAULT NULL,
  `TD_File` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`TD_ID`),
  CONSTRAINT `TD_ID`
    FOREIGN KEY (`TD_ID`)
    REFERENCES `crowdsourcing`.`task` (`TD_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`evaluation_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`evaluation_info` (
  `Parsing_ID` INT NOT NULL,
  `Evaluator_ID` VARCHAR(45) NOT NULL,
  `Evaluation_Time` DATETIME NOT NULL,
  `QualityScore` INT NULL DEFAULT NULL,
  `P_NP` VARCHAR(1) NULL DEFAULT NULL,
  `TaskD_ID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Parsing_ID`, `Evaluator_ID`, `Evaluation_Time`),
  INDEX `evaluation_idx` (`Evaluator_ID` ASC) VISIBLE,
  INDEX `Result_in_idx` (`TaskD_ID` ASC) VISIBLE,
  CONSTRAINT `Evaluator_ID`
    FOREIGN KEY (`Evaluator_ID`)
    REFERENCES `crowdsourcing`.`evaluator` (`AccID_Eval`)
    ON UPDATE CASCADE,
  CONSTRAINT `Parsing_ID`
    FOREIGN KEY (`Parsing_ID`)
    REFERENCES `crowdsourcing`.`pdsequencefile` (`PD_ID`),
  CONSTRAINT `TaskD_ID`
    FOREIGN KEY (`TaskD_ID`)
    REFERENCES `crowdsourcing`.`taskdatatable` (`TD_ID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`evaluating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`evaluating` (
  `Evaluator_ID` VARCHAR(45) NOT NULL,
  `PDS_ID` INT NOT NULL,
  `Eval_Time` DATETIME NOT NULL,
  PRIMARY KEY (`PDS_ID`, `Eval_Time`, `Evaluator_ID`),
  INDEX `Foreign_PD_idx` (`PDS_ID` ASC) VISIBLE,
  INDEX `Foreign_Info1` (`Evaluator_ID` ASC, `PDS_ID` ASC, `Eval_Time` ASC) VISIBLE,
  CONSTRAINT `Foreign_Eval1`
    FOREIGN KEY (`Evaluator_ID`)
    REFERENCES `crowdsourcing`.`evaluator` (`AccID_Eval`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Foreign_Info1`
    FOREIGN KEY (`Evaluator_ID` , `PDS_ID` , `Eval_Time`)
    REFERENCES `crowdsourcing`.`evaluation_info` (`Evaluator_ID` , `Parsing_ID` , `Evaluation_Time`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Foreign_PD1`
    FOREIGN KEY (`PDS_ID`)
    REFERENCES `crowdsourcing`.`pdsequencefile` (`PD_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`submitter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`submitter` (
  `AccID_Submit` VARCHAR(45) NOT NULL,
  `Evaluation` INT NULL DEFAULT NULL,
  PRIMARY KEY (`AccID_Submit`),
  INDEX `Submit_Foreign_idx` (`AccID_Submit` ASC) VISIBLE,
  CONSTRAINT `Submit_Foreign`
    FOREIGN KEY (`AccID_Submit`)
    REFERENCES `crowdsourcing`.`account` (`AccID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`ogdatatype`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`ogdatatype` (
  `ID` INT NOT NULL DEFAULT '5',
  `Og_Schema` JSON NOT NULL,
  `TaskName` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
  INDEX `TaskName_idx` (`TaskName` ASC) VISIBLE,
  CONSTRAINT `TaskName`
    FOREIGN KEY (`TaskName`)
    REFERENCES `crowdsourcing`.`task` (`TName`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`odsequencefile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`odsequencefile` (
  `SerialNumber` INT NOT NULL AUTO_INCREMENT,
  `AccountID` VARCHAR(45) NULL DEFAULT NULL,
  `OGDT_ID` INT NULL DEFAULT NULL,
  `PDS_ID` INT NULL DEFAULT NULL,
  `OD_File` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`SerialNumber`),
  INDEX `fk_ODSEQUENCEFILE_OGDATATYPE1_idx` (`OGDT_ID` ASC) VISIBLE,
  INDEX `fk_ODSEQUENCEFILE_PDSEQUENCEFILE(DecidedLater)1_idx` (`PDS_ID` ASC) INVISIBLE,
  INDEX `AccountID_idx` (`AccountID` ASC) VISIBLE,
  CONSTRAINT `AccountID`
    FOREIGN KEY (`AccountID`)
    REFERENCES `crowdsourcing`.`submitter` (`AccID_Submit`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `OGDT_ID`
    FOREIGN KEY (`OGDT_ID`)
    REFERENCES `crowdsourcing`.`ogdatatype` (`ID`)
    ON UPDATE CASCADE,
  CONSTRAINT `PDS_ID`
    FOREIGN KEY (`PDS_ID`)
    REFERENCES `crowdsourcing`.`pdsequencefile` (`PD_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `crowdsourcing`.`participates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crowdsourcing`.`participates` (
  `Sub_ID` VARCHAR(45) NOT NULL,
  `Task_Name` VARCHAR(45) NOT NULL,
  `Approved` INT NULL DEFAULT '0',
  INDEX `fk_Submitter_has_Task_Submitter1_idx` (`Sub_ID` ASC) VISIBLE,
  INDEX `Task_Name_idx` (`Task_Name` ASC) VISIBLE,
  CONSTRAINT `Part_AccID`
    FOREIGN KEY (`Sub_ID`)
    REFERENCES `crowdsourcing`.`submitter` (`AccID_Submit`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Part_Task_Name`
    FOREIGN KEY (`Task_Name`)
    REFERENCES `crowdsourcing`.`task` (`TName`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
