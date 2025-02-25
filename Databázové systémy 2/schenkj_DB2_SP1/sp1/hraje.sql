--------------------------------------------------------
--  File created - Pátek-dubna-01-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table SP1_XML_HRAJE
--------------------------------------------------------

  CREATE TABLE "SCHENKJ"."SP1_XML_HRAJE" 
   (	"NAZEV" VARCHAR2(256 BYTE), 
	"OBSAH" "XMLTYPE"
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "STUDENTS2020" 
 XMLTYPE COLUMN "OBSAH" STORE AS SECUREFILE BINARY XML (
  TABLESPACE "STUDENTS2020" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ALLOW NONSCHEMA DISALLOW ANYSCHEMA ;
REM INSERTING into SCHENKJ.SP1_XML_HRAJE
SET DEFINE OFF;
Insert into SCHENKJ.SP1_XML_HRAJE (NAZEV,OBSAH) values ('session1','<?xml version="1.0" encoding="UTF-8"?>
<session>
  <hraje>
    <id_hrace>1</id_hrace>
    <id_hry>12</id_hry>
  </hraje>
  <hraje>
    <id_hrace>1</id_hrace>
    <id_hry>18</id_hry>
  </hraje>
  <hraje>
    <id_hrace>2</id_hrace>
    <id_hry>4</id_hry>
  </hraje>
  <hraje>
    <id_hrace>4</id_hrace>
    <id_hry>11</id_hry>
  </hraje>
  <hraje>
    <id_hrace>12</id_hrace>
    <id_hry>11</id_hry>
  </hraje>
  <hraje>
    <id_hrace>13</id_hrace>
    <id_hry>13</id_hry>
  </hraje>
  <hraje>
    <id_hrace>15</id_hrace>
    <id_hry>2</id_hry>
  </hraje>
  <hraje>
    <id_hrace>15</id_hrace>
    <id_hry>12</id_hry>
  </hraje>
</session>
');
