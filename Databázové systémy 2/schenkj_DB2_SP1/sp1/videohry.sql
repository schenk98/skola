--------------------------------------------------------
--  File created - Pátek-dubna-01-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table SP1_XML_VIDEOHRY
--------------------------------------------------------

  CREATE TABLE "SCHENKJ"."SP1_XML_VIDEOHRY" 
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
REM INSERTING into SCHENKJ.SP1_XML_VIDEOHRY
SET DEFINE OFF;
Insert into SCHENKJ.SP1_XML_VIDEOHRY (NAZEV,OBSAH) values ('gamestore1','<?xml version="1.0" encoding="UTF-8"?>
<gamestore>
  <videohra category="FPS">
    <id>3</id>
    <nazev>Counter Strike</nazev>
    <vydavatel>Valve</vydavatel>
    <vekova_hranice>12</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
  </videohra>
  <videohra category="FPS">
    <id>4</id>
    <nazev>Doom</nazev>
    <vydavatel>Doom s.r.o.</vydavatel>
    <vekova_hranice>12</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
    <podpora_konzole>PSP</podpora_konzole>
    <podpora_konzole>Android</podpora_konzole>
  </videohra>
  <videohra category="RPG">
    <id>21</id>
    <nazev>World of Warcraft</nazev>
    <vydavatel>Blizzard Entertainment</vydavatel>
    <vekova_hranice>8</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
  </videohra>
  <videohra category="SandBox">
    <id>12</id>
    <nazev>Minecraft</nazev>
    <vydavatel>Microsoft</vydavatel>
    <vekova_hranice>3</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
    <podpora_konzole>iOS</podpora_konzole>
    <podpora_konzole>Android</podpora_konzole>
    <podpora_konzole>PS4</podpora_konzole>
    <podpora_konzole>XBox One</podpora_konzole>
  </videohra>
</gamestore>
');
Insert into SCHENKJ.SP1_XML_VIDEOHRY (NAZEV,OBSAH) values ('gamestore2','<?xml version="1.0" encoding="UTF-8"?>
<gamestore>
  <videohra category="Retro">
    <id>18</id>
    <nazev>Tetris</nazev>
    <vydavatel>Tetris s.r.o.</vydavatel>
    <vekova_hranice>3</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
    <podpora_konzole>Android</podpora_konzole>
    <podpora_konzole>iOS</podpora_konzole>
  </videohra>
  <videohra category="RPG">
    <id>13</id>
    <nazev>NeverWinter</nazev>
    <vydavatel>Steam</vydavatel>
    <vekova_hranice>8</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
    <podpora_konzole>PS3</podpora_konzole>
  </videohra>
  <videohra category="Platform">
    <id>2</id>
    <nazev>Black Hole</nazev>
    <vydavatel>Fiala Industries</vydavatel>
    <vekova_hranice>3</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
  </videohra>
  <videohra category="Horror">
    <id>17</id>
    <nazev>Slenderman</nazev>
    <vydavatel>Baf a.s.</vydavatel>
    <vekova_hranice>15</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
    <podpora_konzole>Android</podpora_konzole>
    <podpora_konzole>PS4</podpora_konzole>
  </videohra>
  <videohra category="MOBA">
    <id>11</id>
    <nazev>League of Legends</nazev>
    <vydavatel>Small Indie Company</vydavatel>
    <vekova_hranice>8</vekova_hranice>
    <podpora_konzole>PC</podpora_konzole>
  </videohra>
</gamestore>
');
