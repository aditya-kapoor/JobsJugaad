CREATE TABLE "admins" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "password_digest" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "authentications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "employer_id" integer, "provider" varchar(255), "uid" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "employers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "website" varchar(255), "description" text, "password_digest" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "photo_file_name" varchar(255), "photo_content_type" varchar(255), "photo_file_size" integer, "photo_updated_at" datetime, "auth_token" varchar(255), "activated" boolean, "password_reset_token" varchar(255));
CREATE TABLE "job_applications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "interview_on" date, "remarks" text, "job_id" integer, "job_seeker_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "job_seekers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "password_digest" varchar(255), "location" varchar(255), "mobile_number" varchar(255), "experience" varchar(255), "industry" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "photo_file_name" varchar(255), "photo_content_type" varchar(255), "photo_file_size" integer, "photo_updated_at" datetime, "gender" integer(255), "date_of_birth" date, "resume_file_name" varchar(255), "resume_content_type" varchar(255), "resume_file_size" integer, "resume_updated_at" datetime, "auth_token" varchar(255), "activated" boolean, "password_reset_token" varchar(255));
CREATE TABLE "jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "description" text, "location" varchar(255), "employer_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "salary_min" integer, "salary_max" integer, "title" varchar(255), "salary_type" varchar(255));
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "skills" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "skillable_id" integer, "skillable_type" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "skills_associations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "skillable_id" integer, "skillable_type" varchar(255), "skill_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "xyzs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "skillable_id" integer, "skillable_type" varchar(255), "skill_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_sessions_on_session_id" ON "sessions" ("session_id");
CREATE INDEX "index_sessions_on_updated_at" ON "sessions" ("updated_at");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120914060613');

INSERT INTO schema_migrations (version) VALUES ('20120914060627');

INSERT INTO schema_migrations (version) VALUES ('20120914060639');

INSERT INTO schema_migrations (version) VALUES ('20120914060649');

INSERT INTO schema_migrations (version) VALUES ('20120915213445');

INSERT INTO schema_migrations (version) VALUES ('20120919070433');

INSERT INTO schema_migrations (version) VALUES ('20120919074614');

INSERT INTO schema_migrations (version) VALUES ('20120921070343');

INSERT INTO schema_migrations (version) VALUES ('20120921141410');

INSERT INTO schema_migrations (version) VALUES ('20120922060120');

INSERT INTO schema_migrations (version) VALUES ('20120922120236');

INSERT INTO schema_migrations (version) VALUES ('20120926083634');

INSERT INTO schema_migrations (version) VALUES ('20120928103546');

INSERT INTO schema_migrations (version) VALUES ('20120929123324');

INSERT INTO schema_migrations (version) VALUES ('20121001115245');

INSERT INTO schema_migrations (version) VALUES ('20121015140329');

INSERT INTO schema_migrations (version) VALUES ('20121022072506');