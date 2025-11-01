-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema loja_online
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema loja_online
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `loja_online` DEFAULT CHARACTER SET utf8 ;
USE `loja_online` ;

-- -----------------------------------------------------
-- Table `loja_online`.`cidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`cidades` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loja_online`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(80) NOT NULL,
  `endereco` VARCHAR(80) NOT NULL,
  `id_cidade` INT NOT NULL,
  `data_nascimento` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cliente_01_idx` (`id_cidade` ASC) ,
  CONSTRAINT `fk_cliente_01`
    FOREIGN KEY (`id_cidade`)
    REFERENCES `loja_online`.`cidades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loja_online`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`categorias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loja_online`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`produtos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `produto` VARCHAR(50) NOT NULL,
  `id_categoria` INT NOT NULL,
  `preco` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_produtos_01_idx` (`id_categoria` ASC) ,
  CONSTRAINT `fk_produtos_01`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `loja_online`.`categorias` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loja_online`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`pedidos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `data` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pedidos_01_idx` (`id_cliente` ASC) ,
  CONSTRAINT `fk_pedidos_01`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `loja_online`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loja_online`.`pedidos_produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loja_online`.`pedidos_produtos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NOT NULL,
  `id_produto` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pedidos_produtos_01_idx` (`id_pedido` ASC) ,
  INDEX `fk_pedidos_produtos_02_idx` (`id_produto` ASC) ,
  CONSTRAINT `fk_pedidos_produtos_01`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `loja_online`.`pedidos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedidos_produtos_02`
    FOREIGN KEY (`id_produto`)
    REFERENCES `loja_online`.`produtos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
