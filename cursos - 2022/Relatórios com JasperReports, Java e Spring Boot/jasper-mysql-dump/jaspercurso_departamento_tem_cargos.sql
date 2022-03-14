CREATE DATABASE  IF NOT EXISTS `jaspercurso` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `jaspercurso`;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: jaspercurso
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `departamento_tem_cargos`
--

DROP TABLE IF EXISTS `departamento_tem_cargos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento_tem_cargos` (
  `id_departamento` bigint NOT NULL,
  `id_cargo` bigint NOT NULL,
  PRIMARY KEY (`id_departamento`,`id_cargo`),
  KEY `id_cargo_departamento_fk_idx` (`id_cargo`),
  CONSTRAINT `id_cargo_departamento_fk` FOREIGN KEY (`id_cargo`) REFERENCES `cargos` (`id_cargo`),
  CONSTRAINT `id_departamento_cargo_fk` FOREIGN KEY (`id_departamento`) REFERENCES `departamentos` (`id_departamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento_tem_cargos`
--

LOCK TABLES `departamento_tem_cargos` WRITE;
/*!40000 ALTER TABLE `departamento_tem_cargos` DISABLE KEYS */;
INSERT INTO `departamento_tem_cargos` VALUES (1,1),(1,2),(2,2),(3,2),(4,2),(5,2),(7,2),(8,2),(1,3),(2,3),(3,3),(4,3),(5,3),(8,3),(8,4),(8,5),(2,6),(8,6),(4,7),(5,8),(6,9),(6,10),(6,11),(3,12),(7,13),(7,14),(7,15),(7,16),(7,17),(1,18),(2,18),(3,18),(4,18),(5,18),(6,18),(7,18),(8,18);
/*!40000 ALTER TABLE `departamento_tem_cargos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-21 11:51:27
