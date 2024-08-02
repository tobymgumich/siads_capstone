-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS data_prep_id_seq;

-- Table Definition
CREATE TABLE "public"."model_data" (
    "id" int4 NOT NULL DEFAULT nextval('data_prep_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);



-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS model_deploy_id_seq;

-- Table Definition
CREATE TABLE "public"."model_deploy" (
    "id" int4 NOT NULL DEFAULT nextval('model_deploy_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS model_methods_id_seq;

-- Table Definition
CREATE TABLE "public"."model_methods" (
    "id" int4 NOT NULL DEFAULT nextval('model_methods_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS model_setup_id_seq;

-- Table Definition
CREATE TABLE "public"."model_setup" (
    "id" int4 NOT NULL DEFAULT nextval('model_setup_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS model_training_id_seq;

-- Table Definition
CREATE TABLE "public"."model_training" (
    "id" int4 NOT NULL DEFAULT nextval('model_training_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_model_id_seq;

-- Table Definition
CREATE TABLE "public"."model_training_pt" (
    "id" int4 NOT NULL DEFAULT nextval('language_model_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS model_eval_test_id_seq;

-- Table Definition
CREATE TABLE "public"."model_val_test" (
    "id" int4 NOT NULL DEFAULT nextval('model_eval_test_id_seq'::regclass),
    "level_1" varchar,
    "level_2" varchar,
    "level_3" varchar,
    "level_4" varchar,
    "level_5" varchar,
    PRIMARY KEY ("id")
);