--------------------------------------------------------
--  File created - Pátek-dubna-01-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table SP1_XML_HRACI
--------------------------------------------------------

  CREATE TABLE "SCHENKJ"."SP1_XML_HRACI" 
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
REM INSERTING into SCHENKJ.SP1_XML_HRACI
SET DEFINE OFF;
Insert into SCHENKJ.SP1_XML_HRACI (NAZEV,OBSAH) values ('playerbase1','<?xml version="1.0" encoding="UTF-8"?>
<playerbase>
  <hrac typ="Pøíležitostný">
    <id>1</id>
    <jmeno>
      <krestne>Aleš</krestne>
      <prijmeni>Bodrý</prijmeni>
    </jmeno>
    <vek>7</vek>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>Android</typ_konzole>
  </hrac>
  <hrac typ="Pøíležitostný">
    <id>2</id>
    <jmeno>
      <krestne>Bohdana</krestne>
      <prijmeni>Štìdrá</prijmeni>
    </jmeno>
    <vek>32</vek>
    <typ_konzole>Android</typ_konzole>
  </hrac>
  <hrac typ="Retro">
    <id>3</id>
    <jmeno>
      <krestne>Cecil</krestne>
      <prijmeni>Bureš</prijmeni>
    </jmeno>
    <vek>13</vek>
    <typ_konzole>PS4</typ_konzole>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>iOS</typ_konzole>
  </hrac>
  <hrac typ="Vášnivý">
    <id>4</id>
    <jmeno>
      <krestne>Daniel</krestne>
      <prijmeni>Houžvièka</prijmeni>
    </jmeno>
    <vek>25</vek>
    <typ_konzole>PSP</typ_konzole>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>Android</typ_konzole>
    <typ_konzole>XBox One</typ_konzole>
  </hrac>
</playerbase>
');
Insert into SCHENKJ.SP1_XML_HRACI (NAZEV,OBSAH) values ('playerbase2','<?xml version="1.0" encoding="UTF-8"?>
<playerbase>
  <hrac typ="Vášnivý">
    <id>12</id>
    <jmeno>
      <krestne>Magdalena</krestne>
      <prijmeni>Farná</prijmeni>
    </jmeno>
    <vek>18</vek>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>Android</typ_konzole>
  </hrac>
  <hrac typ="Pøíležitostný">
    <id>13</id>
    <jmeno>
      <krestne>Norman</krestne>
      <prijmeni>Hrubý</prijmeni>
    </jmeno>
    <vek>28</vek>
    <typ_konzole>Android</typ_konzole>
    <typ_konzole>PS3</typ_konzole>
  </hrac>
  <hrac typ="Pøíležitostný">
    <id>14</id>
    <jmeno>
      <krestne>Oliver</krestne>
      <prijmeni>Liška</prijmeni>
    </jmeno>
    <vek>7</vek>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>iOS</typ_konzole>
  </hrac>
  <hrac typ="Vášnivý">
    <id>15</id>
    <jmeno>
      <krestne>Pavel</krestne>
      <prijmeni>Líný</prijmeni>
    </jmeno>
    <vek>13</vek>
    <typ_konzole>PS4</typ_konzole>
    <typ_konzole>PC</typ_konzole>
    <typ_konzole>Android</typ_konzole>
  </hrac>
</playerbase>
');
