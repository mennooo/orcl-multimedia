--------------------------------------------------------
--  DDL for Table MULTIMEDIA
--------------------------------------------------------

  CREATE TABLE "DEMO"."MULTIMEDIA" 
   (	"ID" NUMBER, 
	"MEDIA_TYPE" VARCHAR2(20 BYTE), 
	"FILE_NAME" VARCHAR2(255 BYTE), 
  "MIME_TYPE" VARCHAR2(255 BYTE),
	"FILE_LOCATOR" BFILE
   );
--------------------------------------------------------
--  DDL for Index MULTIMEDIA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEMO"."MULTIMEDIA_PK" ON "DEMO"."MULTIMEDIA" ("ID");
--------------------------------------------------------
--  DDL for Trigger MTMD_ID_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "DEMO"."MTMD_ID_TRG" before
  insert on multimedia
  for each row
   WHEN ( new.id is null ) begin
  :new.id := mtmd_id_seq.nextval;
end;

/
ALTER TRIGGER "DEMO"."MTMD_ID_TRG" ENABLE;
--------------------------------------------------------
--  Constraints for Table MULTIMEDIA
--------------------------------------------------------

  ALTER TABLE "DEMO"."MULTIMEDIA" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "DEMO"."MULTIMEDIA" MODIFY ("MEDIA_TYPE" NOT NULL ENABLE);
  ALTER TABLE "DEMO"."MULTIMEDIA" MODIFY ("FILE_NAME" NOT NULL ENABLE);
  ALTER TABLE "DEMO"."MULTIMEDIA" MODIFY ("MIME_TYPE" NOT NULL ENABLE);
  ALTER TABLE "DEMO"."MULTIMEDIA" MODIFY ("FILE_LOCATOR" NOT NULL ENABLE);
  ALTER TABLE "DEMO"."MULTIMEDIA" ADD CONSTRAINT "MTMD_TYPE_CK" CHECK ( media_type in (
    'AUDIO',
    'IMAGE',
    'VIDEO'
  ) ) ENABLE;
  ALTER TABLE "DEMO"."MULTIMEDIA" ADD CONSTRAINT "MULTIMEDIA_PK" PRIMARY KEY ("ID");
