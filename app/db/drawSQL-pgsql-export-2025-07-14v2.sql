CREATE TABLE "Match"(
    "id" BIGINT NOT NULL,
    "Round" VARCHAR(255) NULL,
    "Referee" BIGINT NOT NULL,
    "Stadium" VARCHAR(255) NOT NULL,
    "Date" DATE NOT NULL,
    "Video" VARCHAR(255) NOT NULL,
    "Matchday" INTEGER NOT NULL,
    "Group" SMALLINT NULL
);
ALTER TABLE
    "Match" ADD PRIMARY KEY("id");
CREATE TABLE "Team_Game"(
    "id" BIGINT NOT NULL,
    "Is_host" BOOLEAN NOT NULL,
    "Points" SMALLINT NULL
);
ALTER TABLE
    "Team_Game" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Team_Game"."Points" IS 'Should be calculated from the goals';
CREATE TABLE "Action_Document"(
    "id" BIGINT NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Minute" INTEGER NOT NULL,
    "Half" SMALLINT NULL
);
ALTER TABLE
    "Action_Document" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Action_Document"."Half" IS '1 = first half 2 = second half 3 = Extratime 1 4 = extratime 2 5 = Penalties';
CREATE TABLE "Action_Video"(
    "id" BIGINT NOT NULL,
    "Timestamp" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "Position_x" FLOAT(53) NOT NULL,
    "Position_y" FLOAT(53) NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Minute" INTEGER NOT NULL,
    "Half" SMALLINT NOT NULL
);
ALTER TABLE
    "Action_Video" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Action_Video"."Half" IS '1 = first half 2 = second half 3 = Extratime 1 4 = extratime 2 5 = Penalties';
CREATE TABLE "Player"("id" BIGINT NOT NULL);
ALTER TABLE
    "Player" ADD PRIMARY KEY("id");
CREATE TABLE "Tracking"(
    "id" BIGINT NOT NULL,
    "new_column" BIGINT NOT NULL
);
ALTER TABLE
    "Tracking" ADD PRIMARY KEY("id");
CREATE TABLE "actions"("id" BIGINT NOT NULL);
ALTER TABLE
    "actions" ADD PRIMARY KEY("id");
CREATE TABLE "Lesiones"(
    "id" BIGINT NOT NULL,
    "Surface" VARCHAR(255) NOT NULL,
    "Severity" SMALLINT NOT NULL,
    "type" VARCHAR(255) NOT NULL,
    "date" DATE NOT NULL,
    "return_date" DATE NOT NULL,
    "expected_return_date" DATE NOT NULL,
    "training_date" DATE NOT NULL,
    "expected_training_date" DATE NOT NULL,
    "treatment" VARCHAR(255) NOT NULL,
    "Activity" VARCHAR(255) NOT NULL,
    "Comments" TEXT NOT NULL
);
ALTER TABLE
    "Lesiones" ADD PRIMARY KEY("id");
CREATE TABLE "Bodypart"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Bodypart" ADD PRIMARY KEY("id");
CREATE TABLE "wellness/satisfaction_tests"(
    "id" BIGINT NOT NULL,
    "datetime" DATE NOT NULL,
    "Morale" SMALLINT NOT NULL,
    "Tiredness" SMALLINT NOT NULL
);
ALTER TABLE
    "wellness/satisfaction_tests" ADD PRIMARY KEY("id");
CREATE TABLE "Team"("id" BIGINT NOT NULL);
ALTER TABLE
    "Team" ADD PRIMARY KEY("id");
CREATE TABLE "training"(
    "id" BIGINT NOT NULL,
    "datetime" DATE NOT NULL,
    "type" VARCHAR(255) NOT NULL,
    "Location" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "training" ADD PRIMARY KEY("id");
CREATE TABLE "training_exercise"(
    "id" BIGINT NOT NULL,
    "order" BIGINT NOT NULL,
    "Type" BIGINT NOT NULL
);
ALTER TABLE
    "training_exercise" ADD PRIMARY KEY("id");
CREATE TABLE "Physical_tests"("id" BIGINT NOT NULL);
ALTER TABLE
    "Physical_tests" ADD PRIMARY KEY("id");
ALTER TABLE
    "Lesiones" ADD CONSTRAINT "lesiones_id_foreign" FOREIGN KEY("id") REFERENCES "Player"("id");
ALTER TABLE
    "Tracking" ADD CONSTRAINT "tracking_new_column_foreign" FOREIGN KEY("new_column") REFERENCES "Player"("id");
ALTER TABLE
    "Player" ADD CONSTRAINT "player_id_foreign" FOREIGN KEY("id") REFERENCES "Physical_tests"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Video"("id");
ALTER TABLE
    "Match" ADD CONSTRAINT "match_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Game"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Team"("id");
ALTER TABLE
    "Action_Video" ADD CONSTRAINT "action_video_position_x_foreign" FOREIGN KEY("Position_x") REFERENCES "actions"("id");
ALTER TABLE
    "training" ADD CONSTRAINT "training_id_foreign" FOREIGN KEY("id") REFERENCES "Team"("id");
ALTER TABLE
    "training" ADD CONSTRAINT "training_datetime_foreign" FOREIGN KEY("datetime") REFERENCES "training_exercise"("id");
ALTER TABLE
    "Player" ADD CONSTRAINT "player_id_foreign" FOREIGN KEY("id") REFERENCES "actions"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Tracking"("id");
ALTER TABLE
    "Action_Document" ADD CONSTRAINT "action_document_id_foreign" FOREIGN KEY("id") REFERENCES "Player"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Document"("id");
ALTER TABLE
    "Bodypart" ADD CONSTRAINT "bodypart_id_foreign" FOREIGN KEY("id") REFERENCES "Lesiones"("id");
ALTER TABLE
    "Player" ADD CONSTRAINT "player_id_foreign" FOREIGN KEY("id") REFERENCES "wellness/satisfaction_tests"("id");